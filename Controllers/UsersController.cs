using ElmahCore;
using HelpDeskSystem.ClaimsManagement;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using HelpDeskSystem.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Data;
using System.Net.Mail;
using System.Security.Claims;
using static System.Net.Mime.MediaTypeNames;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission(":USERS")]
    public class UsersController : Controller
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly RoleManager<AppRole> _roleManager;
        private readonly SignInManager<AppUser> _signInManager;
        private readonly ApplicationDbContext _context;

        public UsersController(UserManager<AppUser> userManager, RoleManager<AppRole> roleManager, SignInManager<AppUser> signInManager, ApplicationDbContext context)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _signInManager = signInManager;
            _context = context;
        }

        // GET: UsersController
        //[Permission("DASHBOARD:VIEW")]
        public async Task<ActionResult> Index(string Name, string Email, string Phone, string RoleId)
        {
            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name");

            var users = _context.Users
                .Include(x => x.Role)
                .Include(x => x.Gender)
                .Where(e => e.DelTime == null)
                .AsQueryable();

            if (!string.IsNullOrEmpty(Name))
            {
                users = users.Where(x => x.Name.Contains(Name));
            }

            if (!string.IsNullOrEmpty(Email))
            {
                users = users.Where(x => x.Email.Contains(Email));
            }

            if (!string.IsNullOrEmpty(Phone))
            {
                users = users.Where(x => x.PhoneNumber.Contains(Phone));
            }

            if (!string.IsNullOrEmpty(RoleId))
            {
                users = users.Where(x => x.RoleId.Contains(RoleId));
            }

            return View(await users.ToListAsync());
        }

        // GET: UsersController/Details/5
        public ActionResult Details(string? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var user = _context.Users
                .Include(x => x.Role)
                .Include(x => x.Gender)
                .FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);

            if (user == null)
            {
                return NotFound();
            }

            return View(user);
        }

        // GET: UsersController/Create
        public ActionResult Create()
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description");

            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name");

            return View();
        }

        // POST: UsersController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create(AppUser user)
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description");

            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name");

            try
            {
                var userId = User.GetUserId();

                AppUser user1 = new();

                user1.UserName = user.Email;
                user1.Email = user.Email;
                user1.EmailConfirmed = true;

                user1.Name = user.Name;
                user1.DOB = user.DOB;
                user1.GenderId = user.GenderId;
                user1.RoleId = user.RoleId;
                user1.PhoneNumber = user.PhoneNumber;
                user1.PhoneNumberConfirmed = true;

                user1.CreatedOn = DateTime.Now;
                user1.CreatedById = userId;

                var rolesdetails = await _context.Roles.FirstOrDefaultAsync(x => x.Id == user.RoleId && x.DelTime == null);

                var result = await _userManager.CreateAsync(user1, user.PasswordHash);

                if (result.Succeeded)
                {
                    await _userManager.AddToRoleAsync(user1, rolesdetails.Name);

                    TempData["Message"] = "User Created";

                    return RedirectToAction(nameof(Index));
                }
                else
                {
                    TempData["Error"] = "Error, try again later !";
                    return View(user);
                }
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(user);
            }
        }

        // GET: UsersController/Edit/5
        public async Task<ActionResult> Edit(string? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var user = await _context.Users.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

            if (user == null)
            {
                return NotFound();
            }

            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description");

            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name");

            return View(user);
        }

        // POST: UsersController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit(string id, AppUser user1)
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description");

            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name");

            if (id != user1.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                var user = await _context.Users.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

                if (user != null)
                {
                    user.UserName = user1.Email;
                    user.Email = user1.Email;
                    user.EmailConfirmed = true;

                    user.Name = user1.Name;
                    user.DOB = user1.DOB;
                    user.GenderId = user1.GenderId;
                    user.RoleId = user1.RoleId;
                    user.PhoneNumber = user1.PhoneNumber;
                    user.PhoneNumberConfirmed = true;

                    var rolesdetails = await _context.Roles.FirstOrDefaultAsync(x => x.Id == user.RoleId && x.DelTime == null);

                    await _userManager.RemovePasswordAsync(user);
                    var result = await _userManager.AddPasswordAsync(user, user1.PasswordHash);

                    if (result.Succeeded)
                    {
                        user.ModifiedOn = DateTime.Now;
                        user.ModifiedById = userId;
                        user.LockoutEnabled = true;
                        user.LockoutEnd = null;
                        user.AccessFailedCount = 0;

                        _context.Update(user);
                        await _context.MySaveChangesAsync(userId);

                        await _userManager.AddToRoleAsync(user, rolesdetails.Name);

                        TempData["Message"] = "User Updated";

                        return RedirectToAction(nameof(Index));
                    }
                    else
                    {
                        TempData["Error"] = "Error, try again later !";
                        return View(user1);
                    }
                }
                else
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(user1);
            }
        }

        // GET: UsersController/Delete/5
        public async Task<IActionResult> Delete(string? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var user = await _context.Users.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (user == null)
            {
                return NotFound();
            }

            //return View(user);

            try
            {
                var userId = User.GetUserId();

                if (user != null)
                {
                    user.DelTime = DateTime.Now;

                    _context.Update(user);
                }
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "User Deleted";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: Tickets/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            try
            {
                var userId = User.GetUserId();

                var user = await _context.Users.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

                if (user != null)
                {
                    user.DelTime = DateTime.Now;

                    _context.Update(user);
                }
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "User Deleted";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool UserExists(string id)
        {
            return _context.Users.Any(e => e.Id == id && e.DelTime == null);
        }

        public async Task<ActionResult> Activate(string id)
        {
            var user = await _context.Users.Where(x => x.Id == id).FirstOrDefaultAsync();

            if (user == null)
            {
                return NotFound();
            }

            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender"), "Id", "Description");

            ViewData["RoleId"] = new SelectList(_context.Roles, "Id", "Name");

            return View(user);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Activate(string id, AppUser user1)
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender"), "Id", "Description");

            ViewData["RoleId"] = new SelectList(_context.Roles, "Id", "Name");

            if (id != user1.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                var user = await _context.Users.Where(x => x.Id == id).FirstOrDefaultAsync();

                if (user != null) 
                {
                    user.LockoutEnabled = true;
                    user.LockoutEnd = null;
                    user.AccessFailedCount = 0;
                    user.IsLocked = false;

                    _context.Update(user);
                    await _context.MySaveChangesAsync(userId);

                    return RedirectToAction(nameof(Index));
                }
                else
                {
                    return NotFound();
                }
            }
            catch (DbUpdateConcurrencyException ex)
            {
                ElmahExtensions.RaiseError(ex);

                if (!UserExists(user1.Id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return RedirectToAction(nameof(Index));
        }
    }
}
