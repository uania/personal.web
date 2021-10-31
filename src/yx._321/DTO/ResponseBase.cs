namespace yx._321.DTO
{
    public class ResponseBase
    {
        public int Code{get;set;}

        public string Message { get; set; }
    }

    public class ResponseBase<T> : ResponseBase
    {
        public T Data{get;set;}
    }
}