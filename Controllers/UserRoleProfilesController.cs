using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Models;
using System.Security.Claims;
using HelpDeskSystem.Services;
using HelpDeskSystem.ViewModels;
using Microsoft.AspNetCore.Authorization;
using HelpDeskSystem.ClaimsManagement;
using ElmahCore;
using HelpDeskSystem.Data.Migrations;
using DocumentFormat.OpenXml.Office2010.Excel;
using Microsoft.AspNetCore.Authentication;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission(":ROLES")]
    public class UserRoleProfilesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public UserRoleProfilesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: UserRoleProfiles
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = _context.UserRoleProfiles
                .Include(u => u.CreatedBy)
                .Include(u => u.ModifiedBy)
                .Include(u => u.Role)
                .Include(u => u.Task)
                .Where(e => e.DelTime == null);
            return View(await applicationDbContext.ToListAsync());
        }

        // GET: UserRoleProfiles/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var userRoleProfile = await _context.UserRoleProfiles
                .Include(u => u.CreatedBy)
                .Include(u => u.ModifiedBy)
                .Include(u => u.Role)
                .Include(u => u.Task)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

            if (userRoleProfile == null)
            {
                return NotFound();
            }

            return View(userRoleProfile);
        }

        // GET: UserRoleProfiles/Create
        public IActionResult Create()
        {
            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name");
            ViewData["TaskId"] = new SelectList(_context.SystemTasks.Where(e => e.DelTime == null), "Id", "Name");
            return View();
        }

        // POST: UserRoleProfiles/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(UserRoleProfile userRoleProfile)
        {
            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name", userRoleProfile.RoleId);
            ViewData["TaskId"] = new SelectList(_context.SystemTasks.Where(e => e.DelTime == null), "Id", "Name", userRoleProfile.TaskId);

            try
            {
                var userId = User.GetUserId();

                userRoleProfile.CreatedOn = DateTime.Now;
                userRoleProfile.CreatedById = userId;
                userRoleProfile.DelAble = true;

                _context.Add(userRoleProfile);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Right Created";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(userRoleProfile);
            }
        }

        // GET: UserRoleProfiles/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var userRoleProfile = await _context.UserRoleProfiles.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (userRoleProfile == null)
            {
                return NotFound();
            }

            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name", userRoleProfile.RoleId);
            ViewData["TaskId"] = new SelectList(_context.SystemTasks.Where(e => e.DelTime == null), "Id", "Name", userRoleProfile.TaskId);

            return View(userRoleProfile);
        }

        // POST: UserRoleProfiles/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, UserRoleProfile userRoleProfile)
        {
            if (id != userRoleProfile.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                userRoleProfile.ModifiedOn = DateTime.Now;
                userRoleProfile.ModifiedById = userId;

                _context.Update(userRoleProfile);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Right Updated";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(userRoleProfile);
            }
        }

        // GET: UserRoleProfiles/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var userRoleProfile = await _context.UserRoleProfiles
                .Include(u => u.CreatedBy)
                .Include(u => u.ModifiedBy)
                .Include(u => u.Role)
                .Include(u => u.Task)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (userRoleProfile == null)
            {
                return NotFound();
            }

            return View(userRoleProfile);
        }

        // POST: UserRoleProfiles/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            try
            {
                var userRoleProfile = await _context.UserRoleProfiles.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

                var userId = User.GetUserId();

                if (userRoleProfile != null)
                {
                    //_context.UserRoleProfiles.Remove(userRoleProfile);

                    userRoleProfile.DelTime = DateTime.Now;
                    _context.Update(userRoleProfile);
                }

                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Right Deleted";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool UserRoleProfileExists(int id)
        {
            return _context.UserRoleProfiles.Any(e => e.Id == id && e.DelTime == null);
        }

        [HttpGet]
        public async Task<IActionResult> UserRights(string id, string name)
        {
            ProfileVM vm = new ProfileVM();

            vm.RoleId = id;
            vm.RoleName = name;

            vm.SystemTasks = await _context.SystemTasks
                .Include("ChildTasks.ChildTasks.ChildTasks")
                .OrderBy(x => x.OrderNo)
                .Where(x => x.Parent == null && x.DelTime == null)
                .ToListAsync();

            vm.RightsIdAssigned = await _context.UserRoleProfiles
                .Where(x => x.RoleId == id && x.DelTime == null)
                .Select(x => x.TaskId)
                .ToListAsync();

            return View(vm);
        }

        [HttpPost]
        public async Task<IActionResult> UserRights(ProfileVM vm)
        {
            try
            {
                var allprofile = _context.UserRoleProfiles.Where(x => x.RoleId == vm.RoleId && x.DelTime == null).ToList();
                _context.UserRoleProfiles.RemoveRange(allprofile);

                if (vm.Ids != null)
                {
                    foreach (var taskId in vm.Ids)
                    {
                        var right = new UserRoleProfile
                        {
                            TaskId = taskId,
                            RoleId = vm.RoleId,
                            CreatedOn = DateTime.Now,
                            CreatedById = User.GetUserId()
                        };

                        _context.UserRoleProfiles.Add(right);
                    }
                }
                var userId = User.GetUserId();

                var user = await _context.Users.FirstOrDefaultAsync(e => e.Id == userId && e.DelTime == null);

                await _context.MySaveChangesAsync(userId);

                if (vm.RoleId == user.RoleId)
                {
                    await HttpContext.SignOutAsync();

                    return RedirectToAction("Index", "Home");
                }
                else
                {
                    TempData["Message"] = "Right Assigned";

                    return RedirectToAction("Index", "Roles");
                }
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(vm);
            }
        }
    }
}
