using System;
using System.Net;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using NUnit.Framework;

namespace YouthRoadTests
{
    public class YouthApiIntegrationTests
    {
        private const string BaseUrl = "https://api.youthroad.kr/v1";
        private string _apiKey = string.Empty;

        [SetUp]
        public void SetUp()
        {
            _apiKey = Environment.GetEnvironmentVariable("YOUTHROAD_API_KEY");
            if (string.IsNullOrWhiteSpace(_apiKey))
            {
                Assert.Ignore("YOUTHROAD_API_KEY is not provided; skipping live API checks.");
            }
        }

        [Test]
        public async Task PoliciesEndpoint_ReturnsContent()
        {
            using (var client = CreateClient())
            {
                var response = await client.GetAsync($"/policies?apiKey={_apiKey}&pageIndex=1&pageSize=5");
                var body = await response.Content.ReadAsStringAsync();

                Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
                Assert.IsNotEmpty(body);
            }
        }

        [Test]
        public async Task InstitutionsAndDepartments_ReturnsContent()
        {
            using (var client = CreateClient())
            {
                var institutionsResponse = await client.GetAsync($"/institutions?apiKey={_apiKey}");
                var institutionsBody = await institutionsResponse.Content.ReadAsStringAsync();

                Assert.AreEqual(HttpStatusCode.OK, institutionsResponse.StatusCode);
                Assert.IsNotEmpty(institutionsBody);

                var instNo = ExtractFirstValue(institutionsBody, "\"instNo\"\\s*:\\s*\"?([^\\\"]+)\"?");
                if (string.IsNullOrEmpty(instNo))
                {
                    Assert.Inconclusive("No instNo found in institution response");
                }

                var departmentsResponse = await client.GetAsync($"/departments?apiKey={_apiKey}&instNo={Uri.EscapeDataString(instNo)}");
                var departmentsBody = await departmentsResponse.Content.ReadAsStringAsync();

                Assert.AreEqual(HttpStatusCode.OK, departmentsResponse.StatusCode);
                Assert.IsNotEmpty(departmentsBody);
            }
        }

        private static HttpClient CreateClient()
        {
            return new HttpClient { BaseAddress = new Uri(BaseUrl) };
        }

        private static string ExtractFirstValue(string json, string pattern)
        {
            var match = Regex.Match(json, pattern);
            return match.Success ? match.Groups[1].Value : string.Empty;
        }
    }
}
