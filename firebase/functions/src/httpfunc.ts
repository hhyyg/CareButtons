import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

import * as model from './model';
import * as helper from './helper';

admin.initializeApp();
const firestore = admin.firestore();

interface IRequest {
  readonly twitterId: string;
  readonly invitationKey: string;
}

/**
 * 招待キーから、ユーザーをプロジェクトに参加させる
 * @param data 
 * @param context 
 */
export async function invitation(data: any, context: functions.https.CallableContext): Promise<model.SuccessResult> {

  const request = data as IRequest;
  const twitterId = request.twitterId;
  const invitationKey = request.invitationKey;
  let userId: string = "";
  if (context.auth){
    userId = context.auth.uid;
  }

  //validate arg
  if (!userId) {
    throw new functions.https.HttpsError('unauthenticated');
  }

  if (helper.isNullOrEmpty(twitterId) ||
    helper.isNullOrEmpty(invitationKey) ||
    helper.isNullOrEmpty(userId)) {
      throw new functions.https.HttpsError('invalid-argument');
  }

  //read projectts
  const invitationDoc = await firestore.collection('invitations').doc(invitationKey).get();

  if (!invitationDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'not found invitation');
  }

  const invitationData = invitationDoc.data() as model.IInvitation;
  const projectId = invitationData.projectId;

  const batch = firestore.batch();

  //ProjectIdから、リクエストの権限を足す
  const sharedUsersRef = firestore
    .collection('projects')
    .doc(projectId)
    .collection('sharedUsers');
  const sharedUsers = await sharedUsersRef.get();

  const projectRef = await firestore
    .collection('projects')
    .doc(projectId)
    .get();
  const project = projectRef.data() as model.IProject;

  if (sharedUsers.size > 0) {
    
    //自分がすでに参加中か調べる
    let alreadyJoined = false;
    sharedUsers.forEach(function(doc) {
      const other = doc.data() as model.ISharedUser;
      if (other.userId === userId) {
        alreadyJoined = true;
      }
    });

    if (alreadyJoined) {
      //もし既に自分がそのプロジェクトに参加していたら
      return new model.SuccessResult(projectId);
    }

    const isOwner = (project.ownerUserId === userId);
    if (isOwner) {
      //もし自分がそのプロジェクトのオーナーだったら
      return new model.SuccessResult(projectId);
    }

    throw new functions.https.HttpsError('already-exists', 'already this project is shared');
  }

  const sharedUser: model.ISharedUser = {
    twitterId: twitterId,
    userId: userId,
    sharedAt: new Date()
  };
  batch.set(sharedUsersRef.doc(userId), sharedUser);

  //current projectの設定、既存の紐付けを削除する
  const userRef = firestore
    .collection('users')
    .doc(userId);
  
  batch.set(userRef, {
    currentProjectId: projectId
  }, {merge: true});

  await batch.commit();
    
  return new model.SuccessResult(projectId);
}