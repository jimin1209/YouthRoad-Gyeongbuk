using System;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace YouthRoad.Logging
{
    /// <summary>
    /// Mirrors Unity log entries to a structured message so that Crashlytics or
    /// Sentry captures consistent metadata with Flutter network events.
    /// </summary>
    [DefaultExecutionOrder(-500)]
    public class UnityLogRelay : MonoBehaviour
    {
        [SerializeField]
        [Tooltip("Optional tag to correlate Unity logs with Flutter network breadcrumbs.")]
        private string sessionTag = "unity";

        [SerializeField]
        [Tooltip("Attach stack traces to forwarded messages.")]
        private bool includeStackTrace = true;

        private void OnEnable()
        {
            Application.logMessageReceived += HandleLog;
        }

        private void OnDisable()
        {
            Application.logMessageReceived -= HandleLog;
        }

        private void HandleLog(string condition, string stackTrace, LogType type)
        {
            var payload = new UnityLogPayload
            {
                Level = type.ToString(),
                Message = condition,
                StackTrace = includeStackTrace ? stackTrace : null,
                Scene = SceneManager.GetActiveScene().name,
                DeviceModel = SystemInfo.deviceModel,
                Platform = Application.platform.ToString(),
                SessionTag = sessionTag,
                TimestampIso = DateTimeOffset.UtcNow.ToString("O")
            };

            Debug.unityLogger.Log($"[unity_log] {JsonUtility.ToJson(payload)}");
        }

        [Serializable]
        private class UnityLogPayload
        {
            public string Level;
            public string Message;
            public string StackTrace;
            public string Scene;
            public string DeviceModel;
            public string Platform;
            public string SessionTag;
            public string TimestampIso;
        }
    }
}
