namespace yx._321.MessageWriter
{
    public interface IMessageWriter
    {
        /// <summary>
        /// 记录日志信息
        /// </summary>
        /// <param name="info"></param>
        public void Info(string info);

        /// <summary>
        /// 记录调试信息
        /// </summary>
        /// <param name="info"></param>
        public void Debug(string info);
    }
}