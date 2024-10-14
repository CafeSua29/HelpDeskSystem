using ElmahCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using HelpDeskSystem.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        private readonly ApplicationDbContext _context;

        public HomeController(ILogger<HomeController> logger, ApplicationDbContext context)
        {
            _logger = logger;
            _context = context;
        }

        private async Task CleanAuditsTb()
        {
            try
            {
                var audits = _context.AuditTrails.Where(t => t.DelTime != null).ToList();

                foreach (var audit in audits)
                {
                    _context.AuditTrails.Remove(audit);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanCommentsTb()
        {
            try
            {
                var comments = _context.Comments.Where(t => t.DelTime != null).ToList();

                foreach (var comment in comments)
                {
                    _context.Comments.Remove(comment);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanDepartmentsTb()
        {
            try
            {
                var departments =  _context.Departments.Where(t => t.DelTime != null).ToList();

                foreach (var department in departments)
                {
                    _context.Departments.Remove(department);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanSystemCodesTb()
        {
            try
            {
                var codes = _context.SystemCodes.Where(t => t.DelTime != null).ToList();

                foreach (var code in codes)
                {
                    _context.SystemCodes.Remove(code);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanSystemCodeDetailsTb()
        {
            try
            {
                var codes = _context.SystemCodeDetails.Where(t => t.DelTime != null).ToList();

                foreach (var code in codes)
                {
                    _context.SystemCodeDetails.Remove(code);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanSystemSettingsTb()
        {
            try
            {
                var settings = _context.SystemSettings.Where(t => t.DelTime != null).ToList();

                foreach (var setting in settings)
                {
                    _context.SystemSettings.Remove(setting);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanSystemTasksTb()
        {
            try
            {
                var tasks = _context.SystemTasks.Where(t => t.DelTime != null).ToList();

                foreach (var task in tasks)
                {
                    _context.SystemTasks.Remove(task);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanTicketsTb()
        {
            try
            {
                var tickets = await _context.Tickets.Where(t => t.DelTime != null).ToListAsync();

                if (tickets != null)
                {
                    _context.Tickets.RemoveRange(tickets);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanTicketCategoriesTb()
        {
            try
            {
                var categories = _context.TicketCategories.Where(t => t.DelTime != null).ToList();

                foreach (var category in categories)
                {
                    _context.TicketCategories.Remove(category);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanTicketSubCategoriesTb()
        {
            try
            {
                var categories = _context.TicketSubCategories.Where(t => t.DelTime != null).ToList();

                foreach (var category in categories)
                {
                    _context.TicketSubCategories.Remove(category);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanTicketResolutionsTb()
        {
            try
            {
                var resolutions = await _context.TicketResolutions.Where(t => t.DelTime != null).ToListAsync();
                if (resolutions.Any())
                {
                    _context.TicketResolutions.RemoveRange(resolutions);
                }
                    await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanUsersTb()
        {
            try
            {
                var users = _context.Users.Where(t => t.DelTime != null).ToList();

                foreach (var user in users)
                {
                    _context.Users.Remove(user);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanUserRoleProfilesTb()
        {
            try
            {
                var profiles = _context.UserRoleProfiles.Where(t => t.DelTime != null).ToList();

                foreach (var profile in profiles)
                {
                    _context.UserRoleProfiles.Remove(profile);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        private async Task CleanDb()
        {
            try
            {
                await CleanAuditsTb();

                await CleanSystemSettingsTb();

                await CleanSystemTasksTb();

                await CleanSystemCodeDetailsTb();

                await CleanSystemCodesTb();

                await CleanCommentsTb();

                await CleanDepartmentsTb();

                await CleanTicketSubCategoriesTb();

                await CleanTicketCategoriesTb();

                await CleanTicketResolutionsTb();

                await CleanTicketsTb();

                await CleanUserRoleProfilesTb();

                await CleanUsersTb();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }

        public async Task<IActionResult> Index(TicketDashboardVM vm)
        {
            if(!User.Identity.IsAuthenticated)
            {
                return this.Redirect("~/identity/account/login");
            }
            else
            {
                await CleanDb();

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
    }
}
