// Configuration Firebase complète pour MultiSales Web
// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics, logEvent, setUserProperties } from "firebase/analytics";
import { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut, onAuthStateChanged } from "firebase/auth";
import { getFirestore, collection, addDoc, doc, getDoc, updateDoc, deleteDoc, query, where, orderBy, limit, onSnapshot } from "firebase/firestore";
import { getStorage, ref, uploadBytes, getDownloadURL, deleteObject } from "firebase/storage";
import { getMessaging, getToken, onMessage } from "firebase/messaging";
import { getPerformance, trace } from "firebase/performance";
import { getRemoteConfig, fetchAndActivate, getValue } from "firebase/remote-config";

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBz4EfU40riAMXt3sdKFFFq5Lc_X5W6WGQ",
  authDomain: "multisales-18e57.firebaseapp.com",
  databaseURL: "https://multisales-18e57-default-rtdb.firebaseio.com",
  projectId: "multisales-18e57",
  storageBucket: "multisales-18e57.firebasestorage.app",
  messagingSenderId: "967872205422",
  appId: "1:967872205422:web:b16f6c6b6d6cedc5464c7f",
  measurementId: "G-3DB4WDLJ7X"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase services
const analytics = getAnalytics(app);
const auth = getAuth(app);
const firestore = getFirestore(app);
const storage = getStorage(app);
const messaging = getMessaging(app);
const performance = getPerformance(app);
const remoteConfig = getRemoteConfig(app);

// Configure Remote Config
remoteConfig.settings = {
  minimumFetchIntervalMillis: 3600000, // 1 hour
};

remoteConfig.defaultConfig = {
  'welcome_message': 'Bienvenue dans MultiSales!',
  'min_app_version': '1.0.0',
  'maintenance_mode': false,
  'feature_new_onboarding': true,
  'support_email': 'support@multisales.com',
};

// Export services for use in other modules
export {
  app,
  analytics,
  auth,
  firestore,
  storage,
  messaging,
  performance,
  remoteConfig,
  firebaseConfig
};

// Helper functions for common Firebase operations
export const firebaseServices = {
  // Analytics helpers
  logEvent: (eventName, parameters) => {
    logEvent(analytics, eventName, parameters);
  },

  setUserProperties: (properties) => {
    setUserProperties(analytics, properties);
  },

  // Auth helpers
  signInWithEmail: async (email, password) => {
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);

      // Log analytics event
      logEvent(analytics, 'login', { method: 'email' });

      return { success: true, user: userCredential.user };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  signUpWithEmail: async (email, password, userData = {}) => {
    try {
      const userCredential = await createUserWithEmailAndPassword(auth, email, password);

      // Create user profile in Firestore
      await addDoc(collection(firestore, 'users'), {
        uid: userCredential.user.uid,
        email: email,
        ...userData,
        createdAt: new Date(),
        isOnboardingComplete: false,
      });

      // Log analytics event
      logEvent(analytics, 'sign_up', { method: 'email' });

      return { success: true, user: userCredential.user };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  signOut: async () => {
    try {
      await signOut(auth);
      logEvent(analytics, 'logout');
      return { success: true };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  onAuthStateChanged: (callback) => {
    return onAuthStateChanged(auth, callback);
  },

  // Firestore helpers
  addDocument: async (collectionName, data) => {
    try {
      const docRef = await addDoc(collection(firestore, collectionName), {
        ...data,
        createdAt: new Date(),
      });
      return { success: true, id: docRef.id };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  getDocument: async (collectionName, docId) => {
    try {
      const docSnap = await getDoc(doc(firestore, collectionName, docId));
      if (docSnap.exists()) {
        return { success: true, data: docSnap.data() };
      } else {
        return { success: false, error: 'Document not found' };
      }
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  updateDocument: async (collectionName, docId, data) => {
    try {
      await updateDoc(doc(firestore, collectionName, docId), {
        ...data,
        updatedAt: new Date(),
      });
      return { success: true };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  deleteDocument: async (collectionName, docId) => {
    try {
      await deleteDoc(doc(firestore, collectionName, docId));
      return { success: true };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  queryDocuments: async (collectionName, filters = [], orderByField = null, limitCount = null) => {
    try {
      let q = collection(firestore, collectionName);

      // Apply filters
      filters.forEach(filter => {
        q = query(q, where(filter.field, filter.operator, filter.value));
      });

      // Apply ordering
      if (orderByField) {
        q = query(q, orderBy(orderByField));
      }

      // Apply limit
      if (limitCount) {
        q = query(q, limit(limitCount));
      }

      const querySnapshot = await getDocs(q);
      const documents = [];
      querySnapshot.forEach((doc) => {
        documents.push({ id: doc.id, ...doc.data() });
      });

      return { success: true, data: documents };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  listenToCollection: (collectionName, callback, filters = []) => {
    let q = collection(firestore, collectionName);

    filters.forEach(filter => {
      q = query(q, where(filter.field, filter.operator, filter.value));
    });

    return onSnapshot(q, (querySnapshot) => {
      const documents = [];
      querySnapshot.forEach((doc) => {
        documents.push({ id: doc.id, ...doc.data() });
      });
      callback(documents);
    });
  },

  // Storage helpers
  uploadFile: async (path, file, metadata = {}) => {
    try {
      const storageRef = ref(storage, path);
      const snapshot = await uploadBytes(storageRef, file, metadata);
      const downloadURL = await getDownloadURL(snapshot.ref);

      logEvent(analytics, 'file_upload', {
        file_size: file.size,
        file_type: file.type,
      });

      return { success: true, downloadURL, snapshot };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  getFileURL: async (path) => {
    try {
      const downloadURL = await getDownloadURL(ref(storage, path));
      return { success: true, downloadURL };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  deleteFile: async (path) => {
    try {
      await deleteObject(ref(storage, path));
      return { success: true };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  // Messaging helpers
  requestNotificationPermission: async () => {
    try {
      const permission = await Notification.requestPermission();
      if (permission === 'granted') {
        const token = await getToken(messaging, {
          vapidKey: 'YOUR_VAPID_KEY' // À remplacer par votre clé VAPID
        });
        return { success: true, token };
      } else {
        return { success: false, error: 'Permission denied' };
      }
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  onMessageReceived: (callback) => {
    return onMessage(messaging, callback);
  },

  // Performance helpers
  createTrace: (traceName) => {
    const performanceTrace = trace(performance, traceName);
    performanceTrace.start();
    return {
      stop: () => performanceTrace.stop(),
      putAttribute: (attr, value) => performanceTrace.putAttribute(attr, value),
      putMetric: (metric, value) => performanceTrace.putMetric(metric, value),
    };
  },

  // Remote Config helpers
  initRemoteConfig: async () => {
    try {
      await fetchAndActivate(remoteConfig);
      return { success: true };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  getRemoteConfigValue: (key, defaultValue) => {
    try {
      const value = getValue(remoteConfig, key);
      return value.asString() || defaultValue;
    } catch (error) {
      return defaultValue;
    }
  },

  getRemoteConfigBoolean: (key, defaultValue) => {
    try {
      const value = getValue(remoteConfig, key);
      return value.asBoolean() || defaultValue;
    } catch (error) {
      return defaultValue;
    }
  },

  // Onboarding specific helpers
  startOnboarding: async (userId, userRole) => {
    try {
      // Log analytics
      logEvent(analytics, 'onboarding_start', {
        user_role: userRole,
        timestamp: Date.now(),
      });

      // Create onboarding progress document
      await addDoc(collection(firestore, 'onboarding_progress'), {
        userId: userId,
        userRole: userRole,
        currentStep: 0,
        isComplete: false,
        startedAt: new Date(),
      });

      return { success: true };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  updateOnboardingProgress: async (userId, stepId, stepNumber, totalSteps) => {
    try {
      // Log analytics
      logEvent(analytics, 'onboarding_progress', {
        step_id: stepId,
        step_number: stepNumber,
        total_steps: totalSteps,
        progress_percentage: Math.round((stepNumber / totalSteps) * 100),
      });

      // Update progress in Firestore
      const progressQuery = query(
        collection(firestore, 'onboarding_progress'),
        where('userId', '==', userId)
      );

      // Implementation would continue here...

      return { success: true };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  // Training specific helpers
  startTrainingModule: async (userId, moduleId, moduleName) => {
    try {
      logEvent(analytics, 'training_module_start', {
        module_id: moduleId,
        module_name: moduleName,
      });

      return { success: true };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },

  completeTrainingModule: async (userId, moduleId, moduleName, score, completionTime) => {
    try {
      logEvent(analytics, 'training_module_complete', {
        module_id: moduleId,
        module_name: moduleName,
        score: score,
        completion_time_minutes: completionTime,
      });

      return { success: true };
    } catch (error) {
      return { success: false, error: error.message };
    }
  },
};

// Initialize Remote Config on load
firebaseServices.initRemoteConfig();

// Default export
export default app;
