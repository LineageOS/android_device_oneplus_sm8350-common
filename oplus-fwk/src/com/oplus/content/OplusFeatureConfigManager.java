package com.oplus.content;

import android.os.RemoteException;

public class OplusFeatureConfigManager {
    private static OplusFeatureConfigManager sInstance = null;

    public static OplusFeatureConfigManager getInstance() {
        if (sInstance == null) {
            sInstance = new OplusFeatureConfigManager();
        }
        return sInstance;
    }

    boolean hasFeature() throws RemoteException {
        return false;
    }
}
