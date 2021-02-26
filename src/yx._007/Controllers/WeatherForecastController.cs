using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using yx._321.MessageWriter;

namespace yx._007.Controllers
{
    [ApiController]
    [Route("yx.007")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly IMessageWriter _messgeWriter;

        public WeatherForecastController(IMessageWriter messgeWriter)
        {
            _messgeWriter = messgeWriter;
        }

        [HttpGet]
        public IEnumerable<WeatherForecast> Get()
        {
            _messgeWriter.Info("你说什么");
            _messgeWriter.Debug("这事debug");
            var rng = new Random();
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateTime.Now.AddDays(index),
                TemperatureC = rng.Next(-20, 55),
                Summary = Summaries[rng.Next(Summaries.Length)]
            })
            .ToArray();
        }
    }
}
