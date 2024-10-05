using System.Security.Claims;

namespace HelpDeskSystem.Services
{
    public static class UserAccessService
    {
        public static string GetUserId(this ClaimsPrincipal user) 
        {
            if (!user.Identity.IsAuthenticated)
                return null;
            else
            {
                ClaimsPrincipal curr = user;

                if (curr != null)
                    return curr.FindFirstValue(ClaimTypes.NameIdentifier);
                else
                    return null;
            }
        }

        public static string GetUserName(this ClaimsPrincipal user)
        {
            if (!user.Identity.IsAuthenticated)
                return null;
            else
            {
                ClaimsPrincipal curr = user;

                if (curr != null)
                    return curr.FindFirstValue(ClaimTypes.Name);
                else
                    return null;
            }
        }

        public static string GetUserEmail(this ClaimsPrincipal user)
        {
            if (!user.Identity.IsAuthenticated)
                return null;
            else
            {
                ClaimsPrincipal curr = user;

                if (curr != null)
                    return curr.FindFirstValue(ClaimTypes.Email);
                else
                    return null;
            }
        }

        public static string GetUserRole(this ClaimsPrincipal user)
        {
            if (!user.Identity.IsAuthenticated)
                return null;
            else
            {
                ClaimsPrincipal curr = user;

                if (curr != null)
                    return curr.FindFirst("RoleId").Value;
                else
                    return null;
            }
        }
    }
}
