using AutoMapper;
using Elmah;
using ElmahCore;
using ElmahCore.Mvc;
using HelpDeskSystem.ClaimsManagement;
using HelpDeskSystem.Data;
using HelpDeskSystem.Models;
using HelpDeskSystem.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using XmlFileErrorLog = ElmahCore.XmlFileErrorLog;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));
builder.Services.AddDatabaseDeveloperPageExceptionFilter();

//builder.Services.AddDefaultIdentity<AppUser>(options => options.SignIn.RequireConfirmedAccount = true)
//    .AddEntityFrameworkStores<ApplicationDbContext>();
//builder.Services.AddControllersWithViews();

builder.Services.AddIdentity<AppUser, IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders()
    .AddDefaultUI();
builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages();

builder.Services.AddSingleton<IAuthorizationHandler, PermissionAuthorizationHandler>();

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("Permission", policyBuilder =>
    {
        policyBuilder.Requirements.Add(new PermissionAuthorizationRequirement());
    });
});

builder.Services.AddScoped<IUserClaimsPrincipalFactory<AppUser>, MyUserClaimsPrincipalFactory>().AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = IdentityConstants.ApplicationScheme;
    options.DefaultChallengeScheme = IdentityConstants.ApplicationScheme;
    options.DefaultSignInScheme = IdentityConstants.ApplicationScheme;
})
    .AddCookie(options =>
    {
        options.ExpireTimeSpan = TimeSpan.FromMinutes(30);
        options.SlidingExpiration = true;
        options.Cookie.Name = ".HelpDesk.Session";
        options.Cookie.HttpOnly = true;
        options.Cookie.IsEssential = true;
    });

var config = new MapperConfiguration(
    cfg =>
    {
        if (cfg != null)
        {
            cfg.SourceMemberNamingConvention = new PascalCaseNamingConvention();
            cfg.DestinationMemberNamingConvention = new PascalCaseNamingConvention();
            cfg.AllowNullDestinationValues = true;
            cfg.AddProfile(new AutoMapperProfileService());
        }
    });

var mapper = config.CreateMapper();
builder.Services.AddSingleton(mapper);

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
});

builder.Services.AddCors(options => options.AddPolicy("AllowAllOrigins", builder =>
{
    builder.AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader();
}));

builder.Services.AddSingleton<IActionContextAccessor, ActionContextAccessor>();
builder.Services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();

builder.Services.AddRouting(options => options.LowercaseUrls = true);

builder.Services.AddElmah<XmlFileErrorLog>(options =>
{
    options.Path = "ErrorLogs/errors";
    options.LogPath = builder.Configuration["FileSettings:LogsFolder"];
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseMigrationsEndPoint();
    app.UseElmahExceptionPage();
}
else
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseCookiePolicy();

app.UseElmah();

app.UseRouting();

app.UseSession();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
app.MapRazorPages();

app.Run();
