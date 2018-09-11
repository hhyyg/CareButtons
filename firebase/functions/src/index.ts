import * as functions from 'firebase-functions';
import * as httpFunc from './httpfunc';

export const invitation = functions.https.onCall(async (data: any, context: functions.https.CallableContext) => {
  return httpFunc.invitation(data, context);
});