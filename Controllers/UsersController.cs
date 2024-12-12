using ElmahCore;
using HelpDeskSystem.ClaimsManagement;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using HelpDeskSystem.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Data;
using System.IO;
using System.Net.Mail;
using System.Security.Claims;
using static System.Net.Mime.MediaTypeNames;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    
    public class UsersController : Controller
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly RoleManager<AppRole> _roleManager;
        private readonly SignInManager<AppUser> _signInManager;
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;

        public UsersController(UserManager<AppUser> userManager, RoleManager<AppRole> roleManager, SignInManager<AppUser> signInManager, ApplicationDbContext context, IConfiguration configuration)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _signInManager = signInManager;
            _context = context;
            _configuration = configuration;
        }

        // GET: UsersController
        [Permission(":USERS")]
        [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
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
        [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
        public async Task<IActionResult> Details(string? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var user = await _context.Users
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
        [Permission(":USERS")]
        [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
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
        [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
        [Permission(":USERS")]
        public async Task<ActionResult> Create(AppUser user, IFormFile Avatar)
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description");

            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name");

            try
            {
                var userId = User.GetUserId();

                AppUser user1 = new();

                user1.AvatarCount = 0;

                if (Avatar != null && Avatar.Length > 0)
                {
                    var fileName = user.Email + "_1.jpg";

                    var path = _configuration["FileSettings:AvatarsFolder"];
                    var filePath = Path.Combine(path, fileName);

                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await Avatar.CopyToAsync(stream);
                    }
                    
                    user1.Avatar = fileName;
                    user1.AvatarCount += 1;
                }
                else
                {
                    user1.Avatar = "default-avatar.jpg";
                }

                user1.UserName = user.Email;
                user1.Email = user.Email;
                user1.EmailConfirmed = true;

                user1.Name = user.Name;
                user1.DOB = user.DOB;
                user1.GenderId = user.GenderId;
                user1.RoleId = user.RoleId;
                user1.PhoneNumber = user.PhoneNumber;
                user1.PhoneNumberConfirmed = true;
                user1.Notification = 0;
                user1.Reputation = 0;
                user1.DelAble = true;

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
        [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
        [Permission(":USERS")]
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
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description", user.GenderId);

            return View(user);
        }

        // POST: UsersController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
        [Permission(":USERS")]
        public async Task<ActionResult> Edit(string id, AppUser user1, string? Avatar, IFormFile? NewAvatar)
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description", user1.GenderId);

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
                    if (NewAvatar != null)
                    {
                        var path = _configuration["FileSettings:AvatarsFolder"];

                        if (!string.IsNullOrEmpty(Avatar) && Avatar != "default-avatar.jpg")
                        {
                            var filePath = Path.Combine(path, Avatar);

                            if (System.IO.File.Exists(filePath))
                            {
                                System.IO.File.Delete(filePath);
                            }
                        }

                        user.AvatarCount += 1;

                        var filename = user.Email + "_" + user.AvatarCount + ".jpg";

                        var filepath = Path.Combine(path, filename);

                        using (var stream = new FileStream(filepath, FileMode.Create))
                        {
                            await NewAvatar.CopyToAsync(stream);
                        }

                        user.Avatar = filename;
                    }

                    user.UserName = user1.Email;
                    user.Email = user1.Email;
                    user.EmailConfirmed = true;

                    user.Name = user1.Name;
                    user.DOB = user1.DOB;
                    user.GenderId = user1.GenderId;
                    user.PhoneNumber = user1.PhoneNumber;
                    user.PhoneNumberConfirmed = true;

                    user.ModifiedOn = DateTime.Now;
                    user.ModifiedById = userId;
                    user.LockoutEnabled = true;
                    user.LockoutEnd = null;
                    user.AccessFailedCount = 0;

                    _context.Update(user);
                    await _context.MySaveChangesAsync(userId);

                    if (userId == user1.Id)
                    {
                        await HttpContext.SignOutAsync();

                        return RedirectToAction("Index", "Home");
                    }
                    else
                    {
                        TempData["Message"] = "User Updated";

                        return RedirectToAction(nameof(Index));
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
        [Permission(":USERS")]
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
        [Permission(":USERS")]
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

        [Permission(":USERS")]
        private bool UserExists(string id)
        {
            return _context.Users.Any(e => e.Id == id && e.DelTime == null);
        }

        [Permission(":USERS")]
        public async Task<ActionResult> Activate(string id)
        {
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Permission(":USERS")]
        public async Task<ActionResult> Activate(string id, AppUser user1)
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
                    user.LockoutEnabled = true;
                    user.LockoutEnd = null;
                    user.AccessFailedCount = 0;
                    user.IsLocked = false;

                    _context.Update(user);
                    await _context.MySaveChangesAsync(userId);

                    TempData["Message"] = "User Activated";
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
            }

            return RedirectToAction(nameof(Index));
        }

        [HttpGet]
        [Route("Users/GetUserAvatar")]
        public IActionResult GetUserAvatar(string userId)
        {
            var avatarUrl = _context.Users
                                    .Where(u => u.Id == userId)
                                    .Select(u => u.Avatar)
                                    .FirstOrDefault();

            if (avatarUrl == null)
                return NotFound();

            return Json(new { avatarUrl = avatarUrl });
        }

        [HttpGet]
        [Route("Users/GetUserReputationAndBadge")]
        public IActionResult GetUserReputationAndBadge(string userId)
        {
            var user = _context.Users.FirstOrDefault(u => u.Id == userId);

            if (user == null) return NotFound();

            var reputation = user.Reputation;
            var badge = user.Badge;

            if (reputation == null || reputation < 0 || badge == null)
                return NotFound();

            return Json(new { reputation = reputation, badge = badge });
        }

        [Permission(":USERS")]
        public async Task<ActionResult> AssignRole(string? id)
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

            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name", user.RoleId);

            return View(user);
        }

        // POST: UsersController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Permission(":USERS")]
        public async Task<ActionResult> AssignRole(string id, AppUser user1)
        {
            ViewData["RoleId"] = new SelectList(_context.Roles.Where(e => e.DelTime == null), "Id", "Name", user1.RoleId);

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
                    user.RoleId = user1.RoleId;

                    var rolesdetails = await _context.Roles.FirstOrDefaultAsync(x => x.Id == user1.RoleId && x.DelTime == null);

                    user.ModifiedOn = DateTime.Now;
                    user.ModifiedById = userId;

                    _context.Update(user);
                    await _context.MySaveChangesAsync(userId);

                    await _userManager.AddToRoleAsync(user, rolesdetails.Name);

                    TempData["Message"] = "Role Assigned";

                    if (userId == user1.Id)
                    {
                        await HttpContext.SignOutAsync();

                        return RedirectToAction("Index", "Home");
                    }
                    else
                    {
                        TempData["Message"] = "User Updated";

                        return RedirectToAction(nameof(Index));
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

    }
}
