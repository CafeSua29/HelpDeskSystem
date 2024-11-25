// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
#nullable disable

using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using DocumentFormat.OpenXml.Spreadsheet;
using ElmahCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace HelpDeskSystem.Areas.Identity.Pages.Account.Manage
{
    public class IndexModel : PageModel
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly SignInManager<AppUser> _signInManager;
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;

        public IndexModel(
            UserManager<AppUser> userManager,
            SignInManager<AppUser> signInManager,
            ApplicationDbContext context,
            IConfiguration configuration)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _context = context;
            _configuration = configuration;
        }

        /// <summary>
        ///     This API supports the ASP.NET Core Identity default UI infrastructure and is not intended to be used
        ///     directly from your code. This API may change or be removed in future releases.
        /// </summary>
        public string Username { get; set; }

        /// <summary>
        ///     This API supports the ASP.NET Core Identity default UI infrastructure and is not intended to be used
        ///     directly from your code. This API may change or be removed in future releases.
        /// </summary>
        [TempData]
        public string StatusMessage { get; set; }

        /// <summary>
        ///     This API supports the ASP.NET Core Identity default UI infrastructure and is not intended to be used
        ///     directly from your code. This API may change or be removed in future releases.
        /// </summary>
        [BindProperty]
        public InputModel Input { get; set; }

        /// <summary>
        ///     This API supports the ASP.NET Core Identity default UI infrastructure and is not intended to be used
        ///     directly from your code. This API may change or be removed in future releases.
        /// </summary>
        public class InputModel
        {
            /// <summary>
            ///     This API supports the ASP.NET Core Identity default UI infrastructure and is not intended to be used
            ///     directly from your code. This API may change or be removed in future releases.
            /// </summary>
            [Phone]
            [Required(ErrorMessage = "Phone number is required")]
            [RegularExpression(@"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$", ErrorMessage = "Invalid phone number format")]
            [Display(Name = "Phone number")]
            public string PhoneNumber { get; set; }

            [Required(ErrorMessage = "Name is required")]
            [RegularExpression("^[a-zA-Z0-9][a-zA-Z0-9@. ]*$", ErrorMessage = "Name can only contain alphanemuric characters, spaces, @ and .")]
            [StringLength(30, ErrorMessage = "Name cannot exceed 30 characters")]
            [Display(Name = "Name")]
            public string Name { get; set; }

            [Display(Name = "Gender")]
            public int GenderId { get; set; }

            [Required]
            [Display(Name = "Date of birth")]
            public DateOnly DOB { get; set; }

            [Display(Name = "Avatar")]
            public IFormFile? Avatar { get; set; }
        }

        [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
        private async Task LoadAsync(AppUser user)
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description");

            var userName = await _userManager.GetUserNameAsync(user);
            var phoneNumber = await _userManager.GetPhoneNumberAsync(user);

            var tempUser = await _context.Users.FirstOrDefaultAsync(e => e.Id == user.Id && e.DelTime == null);
            var name = tempUser.Name;
            var genderid = tempUser.GenderId;
            var dob = tempUser.DOB;

            Username = userName;

            Input = new InputModel
            {
                PhoneNumber = phoneNumber,
                Name = name,
                GenderId = genderid,
                DOB = dob
            };
        }

        [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
        public async Task<IActionResult> OnGetAsync()
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description");

            var user = await _userManager.GetUserAsync(User);
            if (user == null)
            {
                return NotFound($"Unable to load user with ID '{_userManager.GetUserId(User)}'.");
            }

            await LoadAsync(user);
            return Page();
        }

        [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
        public async Task<IActionResult> OnPostAsync()
        {
            ViewData["GenderId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Gender" && x.DelTime == null), "Id", "Description");

            var user = await _userManager.GetUserAsync(User);
            if (user == null)
            {
                return NotFound($"Unable to load user with ID '{_userManager.GetUserId(User)}'.");
            }

            if (!ModelState.IsValid)
            {
                await LoadAsync(user);
                return Page();
            }

            var phoneNumber = await _userManager.GetPhoneNumberAsync(user);
            if (Input.PhoneNumber != phoneNumber)
            {
                var setPhoneResult = await _userManager.SetPhoneNumberAsync(user, Input.PhoneNumber);
                if (!setPhoneResult.Succeeded)
                {
                    StatusMessage = "Unexpected error when trying to set phone number.";
                    return RedirectToPage();
                }
            }

            if (Input.Name != user.Name)
            {
                try
                {
                    user.Name = Input.Name;

                    _context.Update(user);
                    await _context.MySaveChangesAsync(user.Id);
                }
                catch (Exception ex)
                {
                    ElmahExtensions.RaiseError(ex);
                    StatusMessage = "Unexpected error when trying to change your name.";

                    return Page();
                }
            }

            if (Input.GenderId != user.GenderId)
            {
                try
                {
                    user.GenderId = Input.GenderId;

                    _context.Update(user);
                    await _context.MySaveChangesAsync(user.Id);
                }
                catch (Exception ex)
                {
                    ElmahExtensions.RaiseError(ex);
                    StatusMessage = "Unexpected error when trying to change your gender.";

                    return Page();
                }
            }

            if (Input.DOB != user.DOB)
            {
                try
                {
                    user.DOB = Input.DOB;

                    _context.Update(user);
                    await _context.MySaveChangesAsync(user.Id);
                }
                catch (Exception ex)
                {
                    ElmahExtensions.RaiseError(ex);
                    StatusMessage = "Unexpected error when trying to change your date of birth.";

                    return Page();
                }
            }

            if (Input.Avatar != null && Input.Avatar.Length > 0)
            {
                try
                {
                    var path = _configuration["FileSettings:AvatarsFolder"];

                    var oldFileName = user.Email + "_" + user.AvatarCount + ".jpg";

                    var filePath = Path.Combine(path, oldFileName);

                    if (System.IO.File.Exists(filePath))
                    {
                        System.IO.File.Delete(filePath);
                    }

                    user.AvatarCount += 1;

                    var newFileName = user.Email + "_" + user.AvatarCount + ".jpg";
                    filePath = Path.Combine(path, newFileName);

                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await Input.Avatar.CopyToAsync(stream);
                    }

                    user.Avatar = newFileName;

                    _context.Update(user);
                    await _context.MySaveChangesAsync(user.Id);
                }
                catch (Exception ex)
                {
                    ElmahExtensions.RaiseError(ex);
                    StatusMessage = "Unexpected error when trying to change your avatar.";

                    return Page();
                }
            }

            await _signInManager.RefreshSignInAsync(user);
            StatusMessage = "Your profile has been updated";
            return RedirectToPage();
        }
    }
}
