using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Security.Claims;

namespace HelpDeskSystem.ClaimsManagement
{
    public class MyUserClaimsPrincipalFactory : UserClaimsPrincipalFactory<AppUser, AppRole>
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly RoleManager<AppRole> _roleManager;
        private readonly ApplicationDbContext _context;

        public MyUserClaimsPrincipalFactory(UserManager<AppUser> userManager, 
            RoleManager<AppRole> roleManager,
            ApplicationDbContext context,
            IOptions<IdentityOptions> options) : base(userManager, roleManager, options)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _context = context;
        }

        protected override async Task<ClaimsIdentity> GenerateClaimsAsync(AppUser user)
        {
            var identity = await base.GenerateClaimsAsync(user);

            var userRole = user.RoleId;

            var role = await _context.Roles.SingleOrDefaultAsync(i => i.Id == userRole);

            if (role != null)
            {
                var permissions = await _context.UserRoleProfiles
                    .Where(p => p.RoleId == role.Id)
                    .Select(p => $"{p.Task.Parent.Code}:{p.Task.Code}")
                    .ToListAsync();

                var allUserPermissions = "";

                foreach (var p in permissions)
                {
                    allUserPermissions += $"{p?.ToUpper()}|";
                }

                identity.AddClaim(new Claim("UserPermission", allUserPermissions));
            }

            return identity;
        }
    }
}
