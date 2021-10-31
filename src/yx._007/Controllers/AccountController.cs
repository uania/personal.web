using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using yx._321.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace yx._007.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        public ResponseBase SignIn()
        {
            return new ResponseBase();
        }
    }
}
