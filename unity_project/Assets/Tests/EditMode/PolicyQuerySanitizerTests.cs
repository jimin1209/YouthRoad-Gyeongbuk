using NUnit.Framework;
using YouthRoad;

namespace YouthRoadTests
{
    public class PolicyQuerySanitizerTests
    {
        [Test]
        public void NormalizeRegion_AllOrEmpty_ReturnsNull()
        {
            Assert.IsNull(PolicyQuerySanitizer.NormalizeRegion("ALL"));
            Assert.IsNull(PolicyQuerySanitizer.NormalizeRegion("   "));
        }

        [Test]
        public void NormalizeRegion_ValidRegion_TrimmedValue()
        {
            Assert.AreEqual("11", PolicyQuerySanitizer.NormalizeRegion(" 11 "));
        }

        [Test]
        public void JoinCategories_TrimsAndDeduplicatesEmpty()
        {
            var joined = PolicyQuerySanitizer.JoinCategories(new[] { " EDUCATION ", "", "HOUSING" });
            Assert.AreEqual("EDUCATION,HOUSING", joined);
        }

        [Test]
        public void JoinCategories_AllEmpty_ReturnsNull()
        {
            var joined = PolicyQuerySanitizer.JoinCategories(new[] { " ", string.Empty });
            Assert.IsNull(joined);
        }

        [Test]
        public void NormalizePage_NonPositive_DefaultsToOne()
        {
            Assert.AreEqual(1, PolicyQuerySanitizer.NormalizePage(0));
            Assert.AreEqual(1, PolicyQuerySanitizer.NormalizePage(-5));
            Assert.AreEqual(3, PolicyQuerySanitizer.NormalizePage(3));
        }

        [Test]
        public void NormalizePageSize_ClampsToBounds()
        {
            Assert.AreEqual(1, PolicyQuerySanitizer.NormalizePageSize(0));
            Assert.AreEqual(1, PolicyQuerySanitizer.NormalizePageSize(-10));
            Assert.AreEqual(50, PolicyQuerySanitizer.NormalizePageSize(50));
            Assert.AreEqual(100, PolicyQuerySanitizer.NormalizePageSize(500));
        }

        [Test]
        public void NormalizeAge_FiltersNonPositive()
        {
            Assert.IsNull(PolicyQuerySanitizer.NormalizeAge(null));
            Assert.IsNull(PolicyQuerySanitizer.NormalizeAge(0));
            Assert.AreEqual(29, PolicyQuerySanitizer.NormalizeAge(29));
        }

        [Test]
        public void NormalizeStatus_TrimAndNullChecks()
        {
            Assert.IsNull(PolicyQuerySanitizer.NormalizeStatus("   "));
            Assert.AreEqual("APPLYING", PolicyQuerySanitizer.NormalizeStatus(" APPLYING "));
        }

        [Test]
        public void NormalizeKeyword_TrimAndNullChecks()
        {
            Assert.IsNull(PolicyQuerySanitizer.NormalizeKeyword(""));
            Assert.AreEqual("주거", PolicyQuerySanitizer.NormalizeKeyword("  주거 "));
        }
    }
}
