# External Integration Status (YouthRoad Flutter + Unity)

## YouthRoad Policy API (Flutter)
- **Endpoint wiring**: `YouthApiService` points to the production base URL `https://api.youthroad.kr/v1` with real endpoints for `/policies`, `/institutions`, and `/departments`; no mock adapters are configured. The request DTO uses API-spec query names (`searchRgnSe`, `searchPolicyType`, `searchPolicyStatus`, `searchAge`, `searchKeyword`, `pageIndex`, `pageSize`).
- **Filter normalization**: `PolicyRepository.getPolicies` drops `ALL`/null regions, trims categories into a comma list, ignores empty status/keyword, and clamps age to positive values before issuing the Retrofit call. This matches the YouthRoad query contract but does not validate that Unity-provided region codes match the API’s numeric codes.
- **Error behavior**: Network failures bubble up from Dio/Retrofit; there is no offline fallback or user-friendly error mapping. Timeouts are set to 10s via `createDioClient`, but retries/backoff are not present.

### TODO
- Surface YouthRoad failures with domain errors (timeout, no connection, 4xx/5xx) and user messaging instead of raw Dio exceptions.
- Replace the hardcoded API key with a runtime-provided secret (env/secure storage) and guard tests when the key is absent.
- Validate/transform Unity region codes to YouthRoad `searchRgnSe` codes before calling the repository to avoid mismatched filters.

## Unity Map Integration
- **Data source**: The Unity project contains only `PolicyQuerySanitizer` tests; there is no Unity scene or script that loads map tiles/boundaries from an external provider. The Flutter `UnityWidget` therefore cannot render live map data today.
- **Message bridge**: Flutter sends `HIGHLIGHT_REGION` once a controller is created and consumes `REGION_SELECTED`/`MAP_READY` messages; sample payloads use `regionCode/regionName`. Unity → Flutter region codes (`GB-GS` example) do not align with YouthRoad numeric region codes used in API filters.

### TODO
- Add a Unity scene with map data loading (tile/GeoJSON provider) and wire `REGION_SELECTED` to emit YouthRoad-compatible region codes.
- Implement a Flutter-side handshake that waits for `MAP_READY` before sending `HIGHLIGHT_REGION`, with timeout/error UI if Unity never responds.
- Log and expose Unity ↔ Flutter message failures to aid debugging in CI and production.
