package lahaina

import (
    "android/soong/android"
)

func init() {
    android.RegisterModuleType("oneplus_lahaina_fod_hal_binary", fodHalBinaryFactory)
}
