using Microsoft.Extensions.Logging;
namespace yx._321.MessageWriter
{
    public class DefaultAchieve : IMessageWriter
    {
        private ILogger _logger;

        public DefaultAchieve(ILogger logger)
        {
            _logger = logger;
        }
        /// <summary>
        /// 记录日志信息
        /// </summary>
        /// <param name="info"></param>
        public void Info(string info)
        {
            _logger.LogInformation(info);
        }

        /// <summary>
        /// 记录调试信息
        /// </summary>
        /// <param name="info"></param>
        public void Debug(string info)
        {
            _logger.LogDebug(info);
        }
    }
}