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
        private static readonly TimeSpan RequestTimeout = TimeSpan.FromSeconds(10);
        private string _apiKey = string.Empty;

        [SetUp]
        public void SetUp()
        {
            var unityLicense = Environment.GetEnvironmentVariable("UNITY_LICENSE");
            if (string.IsNullOrWhiteSpace(unityLicense))
            {
                Assert.Ignore("UNITY_LICENSE is not provided; skipping live API checks.");
            }

            _apiKey = Environment.GetEnvironmentVariable("YOUTHROAD_API_KEY");
            if (string.IsNullOrWhiteSpace(_apiKey))
            {
                Assert.Ignore("YOUTHROAD_API_KEY is not provided; skipping live API checks.");
            }
        }

        [Test]
        public async Task PoliciesEndpoint_ReturnsContent()
        {
            try
            {
                using (var client = CreateClient())
                {
                    var response = await client.GetAsync($"/policies?apiKey={_apiKey}&pageIndex=1&pageSize=5");
                    var body = await response.Content.ReadAsStringAsync();

                    if (response.StatusCode != HttpStatusCode.OK)
                    {
                        TestContext.Out.WriteLine($"Unexpected status {(int)response.StatusCode} from /policies.");
                    }

                    Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
                    Assert.IsNotEmpty(body);
                }
            }
            catch (TaskCanceledException ex)
            {
                LogHttpError(ex, "/policies");
                throw;
            }
            catch (HttpRequestException ex)
            {
                LogHttpError(ex, "/policies");
                throw;
            }
        }

        [Test]
        public async Task InstitutionsAndDepartments_ReturnsContent()
        {
            try
            {
                using (var client = CreateClient())
                {
                    var institutionsResponse = await client.GetAsync($"/institutions?apiKey={_apiKey}");
                    var institutionsBody = await institutionsResponse.Content.ReadAsStringAsync();

                    if (institutionsResponse.StatusCode != HttpStatusCode.OK)
                    {
                        TestContext.Out.WriteLine($"Unexpected status {(int)institutionsResponse.StatusCode} from /institutions.");
                    }

                    Assert.AreEqual(HttpStatusCode.OK, institutionsResponse.StatusCode);
                    Assert.IsNotEmpty(institutionsBody);

                    var instNo = ExtractFirstValue(institutionsBody, "\"instNo\"\\s*:\\s*\"?([^\\\"]+)\"?");
                    if (string.IsNullOrEmpty(instNo))
                    {
                        Assert.Inconclusive("No instNo found in institution response");
                    }

                    var departmentsResponse = await client.GetAsync($"/departments?apiKey={_apiKey}&instNo={Uri.EscapeDataString(instNo)}");
                    var departmentsBody = await departmentsResponse.Content.ReadAsStringAsync();

                    if (departmentsResponse.StatusCode != HttpStatusCode.OK)
                    {
                        TestContext.Out.WriteLine($"Unexpected status {(int)departmentsResponse.StatusCode} from /departments.");
                    }

                    Assert.AreEqual(HttpStatusCode.OK, departmentsResponse.StatusCode);
                    Assert.IsNotEmpty(departmentsBody);
                }
            }
            catch (TaskCanceledException ex)
            {
                LogHttpError(ex, "/institutions or /departments");
                throw;
            }
            catch (HttpRequestException ex)
            {
                LogHttpError(ex, "/institutions or /departments");
                throw;
            }
        }

        private static HttpClient CreateClient()
        {
            return new HttpClient
            {
                BaseAddress = new Uri(BaseUrl),
                Timeout = RequestTimeout,
            };
        }

        private static string ExtractFirstValue(string json, string pattern)
        {
            var match = Regex.Match(json, pattern);
            return match.Success ? match.Groups[1].Value : string.Empty;
        }

        private static void LogHttpError(Exception ex, string path)
        {
            TestContext.Out.WriteLine($"HTTP error while calling {path}: {ex.Message}");
            if (ex is TaskCanceledException)
            {
                TestContext.Out.WriteLine("Request timed out.");
            }
        }
    }
}
