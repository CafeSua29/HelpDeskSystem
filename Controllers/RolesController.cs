using ElmahCore;
using HelpDeskSystem.ClaimsManagement;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using HelpDeskSystem.Services;
using HelpDeskSystem.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Net.Mail;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission(":ROLES")]
    public class RolesController : Controller
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly SignInManager<AppUser> _signInManager;
        private readonly ApplicationDbContext _context;

        public RolesController(UserManager<AppUser> userManager, RoleManager<IdentityRole> roleManager, SignInManager<AppUser> signInManager, ApplicationDbContext context)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _signInManager = signInManager;
            _context = context;
        }

        public async Task<ActionResult> Index()
        {
            var roles = await _context.Roles.ToListAsync();

            return View(roles);
        }

        public async Task<IActionResult> Details(string? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var role = await _context.Roles
                //.Where(t => t.DelTime == null)
                .FirstOrDefaultAsync(m => m.Id == id);

            if (role == null)
            {
                return NotFound();
            }

            return View(role);
        }

        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(RoleVM vm)
        {
            IdentityRole role = new();
            role.Name = vm.Name;

            var result = await _roleManager.CreateAsync(role);

            if(result.Succeeded)
            {
                return RedirectToAction("Index");
            }
            else
            {
                return View(vm);
            }

            //try
            //{
            //    var userId = User.GetUserId();

            //    IdentityRole role = new();
            //    role.Name = vm.Name;
            //    role.CreatedOn = DateTime.Now;
            //    role.CreatedById = userId;

            //    var result = await _roleManager.CreateAsync(role);

            //    if (result.Succeeded)
            //    {
            //        TempData["Message"] = "Role Created";

            //        return RedirectToAction(nameof(Index));
            //    }
            //    else
            //    {
            //        TempData["Error"] = "Error, try again later !";
            //        return View(vm);
            //    }
            //}
            //catch (Exception ex)
            //{
            //    ElmahExtensions.RaiseError(ex);
            //    TempData["Error"] = "Error: " + ex.Message;

            //    return View(vm);
            //}
        }

        // GET: Tickets/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets.FindAsync(id);
            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority" && x.DelTime == null), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status" && x.DelTime == null), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories.Where(x => x.DelTime == null), "Id", "Name");

            return View(ticket);
        }

        // POST: Tickets/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Ticket ticket, IFormFile attachment)
        {
            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority" && x.DelTime == null), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status" && x.DelTime == null), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories.Where(x => x.DelTime == null), "Id", "Name");

            if (id != ticket.Id)
            {
                return NotFound();
            }

            try
            {

                if (ticket.StatusId == 0 || ticket.PriorityId == 0)
                {
                    var pendingstatusid = await _context.SystemCodeDetails
                        .Include(c => c.SystemCode)
                        .Where(c => c.SystemCode.Code == "Status" && c.Code == "Pending" && c.DelTime == null)
                        .FirstOrDefaultAsync();

                    var lowpriorityid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .Where(c => c.SystemCode.Code == "Priority" && c.Code == "Low" && c.DelTime == null)
                    .FirstOrDefaultAsync();

                    ticket.StatusId = pendingstatusid.Id;
                    ticket.PriorityId = lowpriorityid.Id;
                }

                var userId = User.GetUserId();

                ticket.ModifiedOn = DateTime.Now;
                ticket.ModifiedById = userId;

                _context.Update(ticket);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Ticket Updated";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(ticket);
            }
        }

        // GET: Tickets/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (ticket == null)
            {
                return NotFound();
            }

            return View(ticket);

            //ticket = await _context.Tickets.FindAsync(id);
            //if (ticket != null)
            //{
            //    _context.Tickets.Remove(ticket);
            //}

            //await _context.SaveChangesAsync();

            //TempData["Message"] = "Ticket Deleted";

            //return RedirectToAction(nameof(Index));
        }

        // POST: Tickets/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            try
            {
                var userId = User.GetUserId();

                var ticket = await _context.Tickets.FindAsync(id);
                if (ticket != null)
                {
                    //_context.Tickets.Remove(ticket);

                    var comments = await _context.Comments.Where(c => c.TicketId == id && c.DelTime == null).ToListAsync();

                    foreach (var comment in comments)
                    {
                        comment.DelTime = DateTime.Now;
                    }

                    var resolutions = await _context.TicketResolutions.Where(c => c.TicketId == id && c.DelTime == null).ToListAsync();

                    foreach (var resolution in resolutions)
                    {
                        resolution.DelTime = DateTime.Now;

                    }

                    ticket.DelTime = DateTime.Now;
                    _context.UpdateRange(comments);
                    _context.UpdateRange(resolutions);
                    _context.Update(ticket);
                }
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Ticket Deleted";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool TicketExists(int id)
        {
            return _context.Tickets.Any(e => e.Id == id);
        }
    }
}
