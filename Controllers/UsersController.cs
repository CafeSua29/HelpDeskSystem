using ElmahCore;
using HelpDeskSystem.ClaimsManagement;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using HelpDeskSystem.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Net.Mail;
using System.Security.Claims;
using static System.Net.Mime.MediaTypeNames;

namespace HelpDeskSystem.Controllers
{
    public class UsersController : Controller
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly SignInManager<AppUser> _signInManager;
        private readonly ApplicationDbContext _context;

        public UsersController(UserManager<AppUser> userManager, RoleManager<IdentityRole> roleManager, SignInManager<AppUser> signInManager, ApplicationDbContext context)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _signInManager = signInManager;
            _context = context;
        }

        // GET: UsersController
        //[Permission("DASHBOARD:VIEW")]
        public async Task<ActionResult> Index()
        {
            var users = await _context.Users
                .Include(x => x.Role)
                .Include(x => x.Gender)
                .ToListAsync();

            return View(users);
        }

        // GET: UsersController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: UsersController/Create
        public ActionResult Create()
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender"), "Id", "Description");

            ViewData["RoleId"] = new SelectList(_context.Roles, "Id", "Name");

            return View();
        }

        // POST: UsersController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create(AppUser user)
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender"), "Id", "Description");

            ViewData["RoleId"] = new SelectList(_context.Roles, "Id", "Name");

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

                var rolesdetails = await _context.Roles.Where(x => x.Id == user.RoleId).FirstOrDefaultAsync();

                var result = await _userManager.CreateAsync(user1, user.PasswordHash);

                if (result.Succeeded)
                {
                    await _userManager.AddToRoleAsync(user1, rolesdetails.Name);

                    return RedirectToAction(nameof(Index));
                }
                else
                {
                    return View();
                }
            }
            catch
            {
                return View();
            }
        }

        // GET: UsersController/Edit/5
        public async Task<ActionResult> Edit(string id)
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

        // POST: UsersController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit(string id, AppUser user1)
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

                user.UserName = user1.Email;
                user.Email = user1.Email;
                user.EmailConfirmed = true;

                user.Name = user1.Name;
                user.DOB = user1.DOB;
                user.GenderId = user1.GenderId;
                user.RoleId = user1.RoleId;
                user.PhoneNumber = user1.PhoneNumber;
                user.PhoneNumberConfirmed = true;

                var rolesdetails = await _context.Roles.Where(x => x.Id == user.RoleId).FirstOrDefaultAsync();

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
                    await _context.SaveChangesAsync(userId);

                    await _userManager.AddToRoleAsync(user, rolesdetails.Name);

                    return RedirectToAction(nameof(Index));
                }
                else
                {
                    return View();
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

        // GET: UsersController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: UsersController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        private bool UserExists(string id)
        {
            return _context.Users.Any(e => e.Id == id);
        }
    }
}
