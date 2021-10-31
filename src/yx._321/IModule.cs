using Microsoft.Extensions.DependencyInjection;
using System;

namespace yx._321
{
    public interface IModule : IDisposable
    {
         public void  Init(IServiceCollection services);
    }
}