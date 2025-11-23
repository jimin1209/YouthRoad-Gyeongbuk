# Feature status audit

This repository currently lacks most of the requested behaviors from the 22-item checklist.

## Observations

- **Policy data shape is incomplete.** The `Policy` entity only tracks `id`, `title`, `category`, `summary`, `tags`, and an optional `policyUrl`; there are no fields for agency, department, eligibility inputs (age/region), application methods, required documents, or contact info, so many detail/compare requirements cannot be satisfied with the current model.
- **Region selection is stored but not used for fetching.** `RegionNotifier` simply persists the selected region string in `SharedPreferences` and updates local state; the policy list fetcher does not consume this value to request region-filtered data.
- **Policy list fetching now uses a unified filter.** `PolicyListNotifier` calls `fetchPolicies` with a `PolicyFilter`, enabling region, category, and paging inputs to flow through a single filter object when requesting data.
- **Chatbot is not wired to ChatGPT.** `ChatRepository.sendMessage` performs a simple GET to `Env.chatEndpoint` and composes a title/body string; there is no OpenAI Chat Completion request, streaming, or error handling aligned with ChatGPT.

These gaps indicate that the required functionality (region-synchronized listings, filter-driven queries, eligibility checks, policy detail completeness, and real ChatGPT integration) still needs to be built.
