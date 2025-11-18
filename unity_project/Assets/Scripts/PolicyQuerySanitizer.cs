using System;
using System.Collections.Generic;
using System.Linq;

namespace YouthRoad
{
    public static class PolicyQuerySanitizer
    {
        public static string NormalizeRegion(string region)
        {
            if (string.IsNullOrWhiteSpace(region))
            {
                return null;
            }

            return string.Equals(region.Trim(), "ALL", StringComparison.OrdinalIgnoreCase)
                ? null
                : region.Trim();
        }

        public static string JoinCategories(IEnumerable<string> categories)
        {
            if (categories == null)
            {
                return null;
            }

            var normalized = categories
                .Select(category => category?.Trim() ?? string.Empty)
                .Where(category => !string.IsNullOrEmpty(category))
                .ToArray();

            if (normalized.Length == 0)
            {
                return null;
            }

            return string.Join(",", normalized);
        }

        public static int NormalizePage(int page)
        {
            return page <= 0 ? 1 : page;
        }
    }
}
