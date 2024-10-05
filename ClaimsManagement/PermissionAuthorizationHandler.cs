using Microsoft.AspNetCore.Authorization;
using System.Collections;
using System.Linq;
using System.Reflection;
using System.Security.Claims;

namespace HelpDeskSystem.ClaimsManagement
{
    public abstract class AttributeAuthorizationHandler<TRequirement, TAttribute> : AuthorizationHandler<TRequirement>
        where TRequirement : IAuthorizationRequirement 
        where TAttribute : Attribute
    {
        private static IEnumerable<TAttribute> GetAttributesFromEndpoint(object resource)
        {
            var endpoint = resource as Endpoint;

            if (endpoint != null)
                return endpoint.Metadata.OfType<TAttribute>().ToList();

            return Enumerable.Empty<TAttribute>();
        }

        protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, TRequirement requirement)
        {
            var attrs = GetAttributesFromEndpoint(context.Resource);

            return HandleRequirementAsync(context, requirement, attrs);
        }

        protected abstract Task HandleRequirementAsync(
            AuthorizationHandlerContext context, 
            TRequirement requirement, 
            IEnumerable<TAttribute> attrs);
    }

    public class PermissionAuthorizationRequirement : IAuthorizationRequirement
    {

    }

    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true)]
    public class PermissionAttribute : AuthorizeAttribute
    {
        public string Name { get; }

        public PermissionAttribute(string name) : base("Permission")
        {
            Name = name;
        }
    }

    public class PermissionAuthorizationHandler : AttributeAuthorizationHandler<PermissionAuthorizationRequirement, PermissionAttribute>
    {
        protected override async Task HandleRequirementAsync(AuthorizationHandlerContext context, PermissionAuthorizationRequirement requirement, IEnumerable<PermissionAttribute> attrs)
        {
            if (attrs == null || !attrs.Any())
            {
                context.Fail();
                return;
            }

            foreach (var a in attrs)
            {
                var hasPermission = await AuthorizeAsync(context.User, a.Name);

                if (!hasPermission)
                {
                    context.Fail();
                    return;
                }
            }

            context.Succeed(requirement);
        }

        private Task<bool> AuthorizeAsync(ClaimsPrincipal user, string permission)
        {
            var userPermissions = user.FindFirstValue("UserPermission")?.ToLower();

            var hasPermission = Task.FromResult(userPermissions != null && userPermissions.Contains(permission.ToLower()));

            return hasPermission;
        }
    }
}
