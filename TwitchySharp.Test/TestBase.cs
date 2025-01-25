using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using PolyhydraGames.Core.Test;

namespace TwitchySharp.Test;

[TestFixture]
public class TwitchTests
{

#pragma warning disable NUnit1032
    private readonly IHost _host;
#pragma warning restore NUnit1032

    //[TearDown]
    //public void TearDown()
    //{
    //    _host.Dispose();
    //}
    public TwitchTests()
    {

        _host = TestFixtures.GetHost((ctx, services) =>
        {
            services.AddSingleton(new HttpClient());

        });
        //_steamService = _host.Services.GetService<ISteamService>();
    }

    [SetUp]
    public async Task Setup()
    {

        //_steamService = _host.Services.GetRequiredService<ISteamService>();
    }

    [Test]
    public void FakeTest()
    {
        Assert.That(true);
    }


}