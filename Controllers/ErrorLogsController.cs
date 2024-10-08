using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    public class ErrorLogsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
