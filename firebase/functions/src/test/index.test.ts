//import * as functions from 'firebase-functions';
//import * as admin from 'firebase-admin';
import * as fftest from 'firebase-functions-test';
// import * as chai from 'chai';
// const assert = chai.assert;

const test = fftest({
    databaseURL: 'https://carebuttons-dev.firebaseio.com',
    storageBucket: 'carebuttons-dev.appspot.com',
    projectId: 'carebuttons-dev'
  }, `${__dirname}/../../../.vscode/CareButtons Dev-702b5d7bf01d.json`);

describe(`test`, () => {
    after(() => {
        test.cleanup();
    });
    it("空テスト", (done) => {
        done();
    });
});
