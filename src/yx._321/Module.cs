using Microsoft.Extensions.DependencyInjection;
using yx._321.Jwt;
using yx._321.MessageWriter;

namespace yx._321
{
    public class Module:IModule
    {
        public void Dispose()
        {
            
        }

        public void Init(IServiceCollection services)
        {
            services.AddScoped<IMessageWriter, DefaultAchieve>();
            services.AddScoped<IJwter,Jwter>();
        }
    }
}