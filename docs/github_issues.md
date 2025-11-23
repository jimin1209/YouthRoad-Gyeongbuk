# Repository Issue Backlog

## Issue 1 — Expand Policy Entity With Full Metadata Fields
**Description:** Add nullable metadata properties to `Policy` to support comparison, detail display, and eligibility logic.
**Files to Modify:** `lib/domain/entities/policy.dart`
**Exact Code Areas:** `Policy` class constructor and field definitions.
**Acceptance Criteria:**
- Fields `agency`, `department`, `eligibilityAge`, `eligibilityRegion`, `applicationMethod`, `requiredDocuments`, `contact`, `periodStart`, `periodEnd`, `dday`, `isOngoing` exist as nullable properties.
- Constructor preserves current required params; new params are optional.
- Downstream references compile without change.

## Issue 2 — Expand PolicyModel DTO (API Parsing)
**Description:** Map new policy metadata through `PolicyModel` with null-safe JSON handling.
**Files to Modify:** `lib/data/models/policy_model.dart`
**Exact Code Areas:** `PolicyModel` fields, constructor params, `fromJson`, and `toEntity` mapping.
**Acceptance Criteria:**
- All metadata fields from Issue 1 are represented and mapped.
- `fromJson` tolerates absent keys without throwing.
- `toJson` (add if missing) includes new fields when present.

## Issue 3 — Expand LocalPolicySource Mock Data
**Description:** Provide comprehensive mock policy data covering filled/empty metadata for UI testing.
**Files to Modify:** `lib/data/sources/local/local_policy_source.dart`
**Exact Code Areas:** Mock policy list creation and sample data definitions.
**Acceptance Criteria:**
- Each mock policy populates all new fields with varied values (including nulls).
- Policy detail screen renders metadata without crashes.

## Issue 4 — Implement Unified API Filter Parameter Model
**Description:** Introduce a filter data structure for policy fetching and plumb it through repository/API layer.
**Files to Modify:** `lib/data/repositories/policy_repository.dart`; `lib/data/sources/remote/policy_api_source.dart` (if present).
**Exact Code Areas:** Fetch method signatures, filter model definition, request parameter construction.
**Acceptance Criteria:**
- `fetchPolicies` accepts a filter object with optional fields: region, policyType, keyword, year, isAvailable, pageIndex, pageSize.
- Existing callers compile unchanged (default args or overloads provided).
- Filter fields map to API query params when set.

## Issue 5 — Connect selectedRegionProvider → PolicyListProvider
**Description:** Ensure region selection triggers policy list refresh via unified filter.
**Files to Modify:** `lib/application/notifiers/region_notifier.dart`; `lib/application/notifiers/policy_list_notifier.dart`.
**Exact Code Areas:** Region change handlers, policy list refresh logic, provider dependencies.
**Acceptance Criteria:**
- Updating selected region updates the filter used by `policyListNotifier`.
- Region changes automatically trigger a new fetch without manual refresh.

## Issue 6 — Quick Category Filter Integration
**Description:** Wire quick filter buttons to policy fetch filter using mapped API codes.
**Files to Modify:** `lib/ui/screens/policy/list/quick_filter_bar.dart`; `lib/application/notifiers/policy_list_notifier.dart`.
**Exact Code Areas:** Quick filter tap handlers, provider update logic, category-to-policyType mapping.
**Acceptance Criteria:**
- Selecting a category updates the list immediately with API-backed results.
- Active category visually reflected in the UI state.

## Issue 7 — Keyword Search Implementation
**Description:** Send search keywords to policy fetch filter and refresh results.
**Files to Modify:** `lib/ui/screens/policy/list/search_bar.dart`; `lib/application/notifiers/policy_list_notifier.dart`.
**Exact Code Areas:** Search submit handler, filter update call, debounce (if present).
**Acceptance Criteria:**
- Submitting non-empty keyword filters results; clearing input resets to full list.
- No crashes on rapid repeated searches.

## Issue 8 — Search History Persistence
**Description:** Persist recent search terms with SharedPreferences service for reuse in UI.
**Files to Modify:** `lib/application/services/search_history_service.dart` (new file) plus wiring where search executes.
**Exact Code Areas:** Save/retrieve/clear methods, SharedPreferences keys, call sites in search flow.
**Acceptance Criteria:**
- Stores up to 10 unique keywords, ordered by recency with no duplicates.
- Clearing history removes stored entries.

## Issue 9 — Eligibility Logic Implementation
**Description:** Compute eligibility (Y/N) based on region and age constraints per policy.
**Files to Modify:** `lib/application/services/eligibility_service.dart` (new).
**Exact Code Areas:** Eligibility function implementing region/age checks and returning string or enum.
**Acceptance Criteria:**
- Given user region/age and policy metadata, returns "Y" when both match, else "N".
- Compare page consumes this result for each policy.

## Issue 10 — Compare Page Data Preparation Fix
**Description:** Ensure compare page displays fallback text for missing fields to avoid blanks.
**Files to Modify:** `lib/ui/screens/policy/compare/policy_compare_page.dart`.
**Exact Code Areas:** Data binding for agency/department/contact/etc. where nulls may occur.
**Acceptance Criteria:**
- Any null/empty field shows "정보 없음" in the compare table.
- Layout remains stable with fallbacks.

## Issue 11 — Compare Page UI Layout Upgrade
**Description:** Improve alignment and wrapping in compare table for readability.
**Files to Modify:** `lib/ui/screens/policy/compare/policy_compare_page.dart`.
**Exact Code Areas:** Row/column layout definitions, text widgets, padding/margin settings.
**Acceptance Criteria:**
- Each row aligns fields horizontally between policies.
- Long text wraps without overflow; consistent padding across rows.

## Issue 12 — PolicyDetail P2 Metadata Sections
**Description:** Connect detailed metadata (application method, required docs, contact, eligibility) into detail UI.
**Files to Modify:** `lib/ui/screens/policy/policy_detail_sections.dart` (or equivalent detail section widgets).
**Exact Code Areas:** Section widgets for 신청방법, 구비서류, 문의처, 지원대상/내용; null-safe display logic.
**Acceptance Criteria:**
- Each section renders header + content from policy metadata.
- Null or empty values render fallback text without errors.

## Issue 13 — Tag / Category Mapping in Detail and Cards
**Description:** Show policy categories/types as tag chips consistently on cards and detail pages.
**Files to Modify:** `lib/ui/screens/policy/policy_detail_screen.dart`; `lib/ui/widgets/policy_card.dart` (or equivalent card widget).
**Exact Code Areas:** Tag chip generation, style reuse, mapping from category/type lists.
**Acceptance Criteria:**
- Multiple tags display when available; styling consistent between list and detail views.
- Absence of tags does not break layout.

## Issue 14 — Similar Policy Recommendation
**Description:** Display up to three recommended policies sharing category or region on detail page.
**Files to Modify:** `lib/data/repositories/policy_repository.dart`; `lib/ui/screens/policy/policy_detail_screen.dart`.
**Exact Code Areas:** Repository method for recommendation fetch/filter; UI section rendering recommended items.
**Acceptance Criteria:**
- Detail page shows 1–3 recommendations when matching policies exist; hides section when none.
- Recommendation tap navigates to selected policy detail.

## Issue 15 — Per-Policy Memo Persistence
**Description:** Save user memos per policy locally using SharedPreferences.
**Files to Modify:** `lib/application/services/memo_repository.dart` (new file) and UI call sites where memos are edited.
**Exact Code Areas:** Save/load/delete memo methods keyed by `memo_{policyId}`; wiring from memo UI.
**Acceptance Criteria:**
- Memo persists across app restarts; retrieving returns last saved text per policy.
- Clearing memo removes stored value.

## Issue 16 — WebView Integration for policyUrl
**Description:** Replace placeholder dialog with WebView page that loads policy URL with loading indicator.
**Files to Modify:** `lib/ui/screens/policy/policy_detail_screen.dart`; `lib/ui/screens/policy/policy_webview_page.dart` (new).
**Exact Code Areas:** Navigation from detail screen to WebView, WebView widget configuration, loading state handling.
**Acceptance Criteria:**
- When `policyUrl` is present, tapping link opens WebView; absent URL shows graceful message.
- WebView shows loading indicator until page loads.

## Issue 17 — Replace Dummy Chatbot HTTP With ChatGPT API
**Description:** Integrate OpenAI Chat Completion in chat repository and notifier with robust error handling.
**Files to Modify:** `lib/data/repositories/chat_repository.dart`; `lib/application/notifiers/chat_notifier.dart`.
**Exact Code Areas:** API request construction, response parsing, error fallback messages, state updates.
**Acceptance Criteria:**
- Chat requests reach OpenAI endpoint and surface AI responses in UI state.
- Network/API errors produce user-visible fallback message without crash.

## Issue 18 — Chatbot UI Improvements
**Description:** Modernize chatbot screen with better input UX, loading spinner, and wrapped message bubbles.
**Files to Modify:** `lib/ui/screens/chatbot/chatbot_screen.dart`.
**Exact Code Areas:** Input field widget, send button handling, loading indicator placement, message bubble layout.
**Acceptance Criteria:**
- Sending displays spinner until response arrives; messages wrap within screen width.
- Input remains accessible while loading; send disabled during request if appropriate.
- Status: Completed — chat bubbles, history reset, loading state, and error/snackbar handling implemented for interactive UX.

## Issue 19 — KakaoMap JS WebView Fix
**Description:** Ensure KakaoMap WebView loads JS SDK, centers on selected region, and shows markers.
**Files to Modify:** `lib/ui/screens/map/kakao_map_page.dart`.
**Exact Code Areas:** WebView initialization, JS SDK injection, center coordinate setup, marker creation logic.
**Acceptance Criteria:**
- Map renders with Kakao tiles visible; centers on selected region default coordinates.
- Markers appear for policies (mock or live) and are interactive.

## Issue 20 — Map + List Sync
**Description:** Synchronize list scrolling with map camera and allow map taps to update list filters.
**Files to Modify:** `lib/ui/screens/map/map_with_list_page.dart`.
**Exact Code Areas:** Scroll listener → map camera movement; map tap callback → filter update and list refresh.
**Acceptance Criteria:**
- Selecting a list item recenters the map; tapping a map area filters/updates the list accordingly.
- No infinite refresh loops or crashes during sync.

## Issue 21 — Unity Map Integration
**Description:** Implement two-way messaging between Flutter and Unity for map markers.
**Files to Modify:** `lib/application/controllers/unity_map_controller.dart`; Unity widget files under `unity` integration directory.
**Exact Code Areas:** Message channel setup, callbacks for marker taps, marker spawn commands from Flutter to Unity.
**Acceptance Criteria:**
- Flutter can send marker data to Unity; Unity responds with callbacks handled in Flutter.
- Marker tap in Unity triggers navigation to corresponding policy detail in Flutter.

## Issue 22 — App-Wide Provider/Router/Theme Cleanup
**Description:** Remove debug artifacts, add network error fallback UI, and enforce proper dispose patterns across app/router/theme.
**Files to Modify:** `lib/app.dart`; routing setup file (e.g., `lib/router.dart`); theme configuration files.
**Exact Code Areas:** DEBUG ribbons removal, global error widget, provider/router dispose logic, theme consistency definitions.
**Acceptance Criteria:**
- No DEBUG labels in release builds; app shows retry/offline UI on network errors.
- Navigating between pages does not leak controllers/providers; theme applied consistently.
