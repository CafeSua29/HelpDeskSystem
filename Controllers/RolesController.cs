﻿using DocumentFormat.OpenXml.Spreadsheet;
using ElmahCore;
using HelpDeskSystem.ClaimsManagement;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using HelpDeskSystem.Services;
using HelpDeskSystem.ViewModels;
using Microsoft.AspNetCore.Authentication;
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
        private readonly RoleManager<AppRole> _roleManager;
        private readonly SignInManager<AppUser> _signInManager;
        private readonly ApplicationDbContext _context;

        public RolesController(UserManager<AppUser> userManager, RoleManager<AppRole> roleManager, SignInManager<AppUser> signInManager, ApplicationDbContext context)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _signInManager = signInManager;
            _context = context;
        }

        public async Task<ActionResult> Index()
        {
            var roles = await _context.Roles.Include(t => t.CreatedBy).Where(t => t.DelTime == null).ToListAsync();

            return View(roles);
        }

        public async Task<IActionResult> Details(string? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var role = await _context.Roles
                .Include(t => t.CreatedBy)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

            ViewBag.Rights = await _context.UserRoleProfiles
                .Include(t => t.Task)
                .Where(e => e.RoleId == id && e.DelTime == null)
                .ToListAsync();

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
        public async Task<IActionResult> Create(AppRole role)
        {
            try
            {
                var userId = User.GetUserId();

                role.CreatedOn = DateTime.Now;
                role.CreatedById = userId;
                role.DelAble = true;

                var result = await _roleManager.CreateAsync(role);

                if (result.Succeeded)
                {
                    TempData["Message"] = "Role Created";

                    return RedirectToAction(nameof(Index));
                }
                else
                {
                    TempData["Error"] = "Error, try again later !";
                    return View(role);
                }
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(role);
            }
        }

        // GET: Tickets/Edit/5
        public async Task<IActionResult> Edit(string? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var role = await _context.Roles.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (role == null)
            {
                return NotFound();
            }

            return View(role);
        }

        // POST: Tickets/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, AppRole role)
        {
            if (id != role.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                role.ModifiedOn = DateTime.Now;
                role.ModifiedById = userId;

                _context.Update(role);
                await _context.MySaveChangesAsync(userId);

                var user = await _context.Users.FirstOrDefaultAsync(e => e.Id == userId && e.DelTime == null);

                if (role.Id == user.RoleId)
                {
                    await HttpContext.SignOutAsync();

                    return RedirectToAction("Index", "Home");
                }
                else
                {
                    TempData["Message"] = "Role Updated";

                    return RedirectToAction(nameof(Index));
                }
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(role);
            }
        }

        // GET: Tickets/Delete/5
        public async Task<IActionResult> Delete(string? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var role = await _context.Roles.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (role == null)
            {
                return NotFound();
            }

            return View(role);
        }

        // POST: Tickets/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            try
            {
                //var allprofile = _context.UserRoleProfiles.Where(x => x.RoleId == id && x.DelTime == null).ToList();
                //_context.UserRoleProfiles.RemoveRange(allprofile);

                var userId = User.GetUserId();

                var role = await _context.Roles.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

                if (role != null)
                {
                    role.DelTime = DateTime.Now;

                    _context.Update(role);

                    var normaluserid = _context.Roles.Where(c => c.Name == "Normal User" && c.DelTime == null).FirstOrDefault();

                    var users = _context.Users.Where(c => c.RoleId == id && c.DelTime == null).ToList();

                    foreach (var user in users)
                    {
                        user.RoleId = normaluserid.Id;

                        _context.Update(user);
                    }

                    var rights = _context.UserRoleProfiles.Where(c => c.RoleId == id && c.DelTime == null).ToList();

                    foreach (var right in rights)
                    {
                        right.DelTime = DateTime.Now;

                        _context.Update(right);
                    }
                }

                await _context.MySaveChangesAsync(userId);

                var curruser = await _context.Users.FirstOrDefaultAsync(e => e.Id == userId && e.DelTime == null);

                if (role.Id == curruser.RoleId)
                {
                    await HttpContext.SignOutAsync();

                    return RedirectToAction("Index", "Home");
                }
                else
                {
                    TempData["Message"] = "Role Deleted";
                }
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
            return _context.Tickets.Any(e => e.Id == id && e.DelTime == null);
        }
    }
}
