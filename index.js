const functions = require('firebase-functions');

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
    // console.log('test log record')
    // testSelectingUsers();

    response.send("Hello from this firebase :-) ! # 2");
});

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
admin.firestore().settings({ timestampsInSnapshots: true, });

exports.testGetUsers = functions.https.onRequest((request, response) => {

    var stuff = [];
    var db = admin.firestore();

    // db.collection('users').where('userRole', '==', 0).get().then(snapshot => {
    db.collection('users').get().then(snapshot => {
        snapshot.forEach(doc => {
            var newElement = {
                "id": doc.id,
                "data": doc.data()
            };
            stuff = stuff.concat(newElement);
        });
        response.send(stuff);
        return "";
    }).catch(error => {
        response.send(error);
    });
});

function getAdjustedTime(hour, minute, frequency) {
    if (frequency === 0) {
        return null;
    }

    const currentDate = new Date();
    const currentYear = currentDate.getUTCFullYear();
    const currentMonth = currentDate.getUTCMonth();
    var currentDay = currentDate.getUTCDate();
    const currentHour = currentDate.getUTCHours();
    const currentMinutes = currentDate.getMinutes();
    const currentDayOfWeek = currentDate.getUTCDay();

    var startFromDay = currentDayOfWeek + 1;
    currentDay++;

    if (startFromDay > 6) {
        startFromDay = 0;
    }

    if (currentHour < hour) {
        if (currentMinutes < minute) {
            startFromDay = currentDayOfWeek;
            currentDay = currentDate.getUTCDate();
        }
    }

    var shiftDays;

    for (var i = 0; i < 7; i++) {
        if (checkDay(startFromDay, frequency)) {
            shiftDays = i;
            break;
        } else {
            startFromDay++;
            if (startFromDay > 6) {
                startFromDay = 0;
            }
        }
    }

    var newDay = currentDay + shiftDays;
    const result = new Date(currentYear, currentMonth, newDay, hour, minute);
    return result;
}

function checkDay(checkedDay, frequency) {
    const monday = 1;
    const tuesday = 2;
    const wednesday = 4;
    const thursday = 16;
    const friday = 256;
    const saturday = 65536;
    const sunday = 16777216;

    switch (checkedDay) {
        case 0:
            if ((frequency & sunday) === sunday) {
                return true;
            }
            break;
        case 1:
            if ((frequency & monday) === monday) {
                return true;
            }
            break;
        case 2:
            if ((frequency & tuesday) === tuesday) {
                return true;
            }
            break;
        case 3:
            if ((frequency & wednesday) === wednesday) {
                return true;
            }
            break;
        case 4:
            if ((frequency & thursday) === thursday) {
                return true;
            }
            break;
        case 5:
            if ((frequency & friday) === friday) {
                return true;
            }
            break;
        default:
            if ((frequency & saturday) === saturday) {
                return true;
            }
            break;
    }

    return false;
}

exports.advicesScheduleChanged = functions.firestore
    .document('advicesSchedule/{userId}').onUpdate((change, context) => {
        const newAdviceSchedule = change.after.data();
        const userId = change.after.id;

        var db = admin.firestore();

        db.collection('subscriptionSchedule').doc(userId).get().then(snapshot => {
            var adviceTime;
            var articleTime;

            const hour = newAdviceSchedule.hour - newAdviceSchedule.shiftToUTC;
            adviceTime = getAdjustedTime(hour, newAdviceSchedule.minute, newAdviceSchedule.frequency);
            articleTime = snapshot.data().articleTime;

            return db.collection('subscriptionSchedule').doc(userId).set({
                adviceTime: adviceTime,
                articleTime: articleTime
            });
        }).catch(error => {
            console.log(error);
        });

        return "";
    });

exports.articlesScheduleChanged = functions.firestore
    .document('articlesSchedule/{userId}').onUpdate((change, context) => {
        const newArticleSchedule = change.after.data();
        const userId = change.after.id;

        var db = admin.firestore();

        db.collection('subscriptionSchedule').doc(userId).get().then(snapshot => {
            var adviceTime;
            var articleTime;

            const hour = newArticleSchedule.hour - newArticleSchedule.shiftToUTC;
            adviceTime = snapshot.data().adviceTime;
            articleTime = getAdjustedTime(hour, newArticleSchedule.minute, newArticleSchedule.frequency);

            return db.collection('subscriptionSchedule').doc(userId).set({
                adviceTime: adviceTime,
                articleTime: articleTime
            });
        }).catch(error => {
            console.log(error);
        });

        return "";
    });

exports.createSubscriptionSchedule = functions.firestore
    .document('users/{userId}').onCreate((snap, context) => {
        const userId = snap.id;
        var db = admin.firestore();

        return db.collection('subscriptionSchedule').doc(userId).set({
            adviceTime: null,
            articleTime: null
        });
    });