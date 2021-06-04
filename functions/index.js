const functions = require("firebase-functions");

const admin = require('firebase-admin');
admin.initializeApp();
exports.onFollowUser = functions.firestore.document('/followers/{userId}/userFollowers/{follwerId}')
.onCreate(async(_,context)=>{
    const userId = context.params.userId;
    const followerId = context.params.follwerId;
    //increment followed count
    const followedUserRef = admin.firestore().collection('users').doc(userId);
    const followedUserDoc = await followedUserRef.get();
    if(followedUserDoc.get('followers') !== undefined){
        followedUserRef.update({followers:followedUserDoc.get('followers')+1});
    }else{
        followedUserRef.update({followers:1});
    }
    //increment users following count
    const userRef = admin.firestore().collection('users').doc(followerId);
    const userDoc = await userRef.get();
    if(userDoc.get('following') !== undefined){
        userRef.update({following:userDoc.get('following')+1});
    }else{
        userRef.update({following:1});
    }

    //add followed users posts to the feed
    const followedUserPostRef = admin.firestore().collection('posts').where('author','==',followedUserRef);
    const userFeedRef = admin.firestore().collection('feeds').doc(followerId).collection('userFeed');
    const followedUserPostSnapShot = await followedUserPostRef.get();
    followedUserPostSnapShot.forEach((doc)=>{
        if(doc.exists){
            userFeedRef.doc(doc.id).set(doc.data());
        }
    });
});

exports.onUnfollowUser = functions.firestore.document('/followers/{userId}/userFollowers/{followerId}')
.onDelete(async(_,context)=>{
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const followedUserRef = admin.firestore().collection('users').doc(userId);
    const followedUserDoc = await followedUserRef.get();
    if(followedUserDoc.get('followers') !== undefined){
        followedUserRef.update({followers:followedUserDoc.get('followers')-1});
    }else{
        followedUserRef.update({followers:0});
    }

    const userRef = admin.firestore().collection('users').doc(followerId);
    const userDoc = await userRef.get();
    if(userDoc.get('following') !== undefined){
        userRef.update({following:userDoc.get('following')-1});
    }else{
        userRef.update({following:0});
    }

    const userFeedRef = admin.firestore()
    .collection('feeds')
    .doc(followerId)
    .collection('userFeed')
    .where('author','==',followedUserRef);
    
    const userSnapShot = await userFeedRef.get();
    userSnapShot.forEach((doc)=>{
        if(doc.exists){
            doc.ref.delete();
        }
    });
});

exports.onCreatePost = functions.firestore.document('/posts/{postId}')
.onCreate(async(_,context)=>{
    const postId = context.params.postId;
    const authorRef = snapshot.get('author');
    const authorId = authorRef.path.split('/')[1];

    const userFollowersRef = admin.firestore().collection('followers').doc(authorId).collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach((doc)=>{
        admin.firestore().collection('feeds').doc(doc.id).collection('userFeed').doc(postId).set(snapshot.data());
    });
});

exports.onUpdatePost = functions.firestore.document('/posts/{postId}')
.onUpdate(async (_,context)=>{
    const postId = context.params.postId;
    const authorRef = snapshot.after.get('author');
    const authorId = authorRef.path.split('/')[1];

    const updatedPostData = snapshot.after.data();
    const userFollowersRef = admin.firestore().collection('followers').doc(authorId).collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach(async (doc)=>{
        const postRef = admin.firestore().collection('feeds').doc(doc.id).collection('userFeed');
        const postDoc = await postRef.doc(postId).get();
        if(postDoc.exists){
            postDoc.ref.update(updatedPostData);
        }
    });
});