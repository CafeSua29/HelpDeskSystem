using HelpDeskSystem.Data;
using HelpDeskSystem.Models;
using HelpDeskSystem.ViewModels;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HelpDeskSystem.Controllers
{
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
        }
    }
}
