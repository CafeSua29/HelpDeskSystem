using ElmahCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using HelpDeskSystem.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Quartz.Impl;
using Quartz;
using System.Diagnostics;

namespace HelpDeskSystem.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        private readonly ApplicationDbContext _context;

        public HomeController(ILogger<HomeController> logger, ApplicationDbContext context)
        {
            _logger = logger;
            _context = context;
        }

        [Authorize]
        public async Task<IActionResult> Index(TicketDashboardVM vm)
        {
            if(!User.Identity.IsAuthenticated)
            {
                return this.Redirect("~/identity/account/login");
            }
            else
            {
                vm.TicketsSummary =  await _context.TicketsSummaryView.FirstOrDefaultAsync();

                vm.TicketsPriority = await _context.TicketsPriorityView.FirstOrDefaultAsync();

                return View(vm);
            }
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public IActionResult Home()
        {
            return View();
        }
    }
}
