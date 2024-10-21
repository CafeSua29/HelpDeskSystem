using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Models;
using HelpDeskSystem.Data.Migrations;
using System.Security.Claims;
using HelpDeskSystem.Services;
using Microsoft.AspNetCore.Authorization;
using HelpDeskSystem.ClaimsManagement;
using ElmahCore;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission(":SYSTEM")]
    public class SystemSettingsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public SystemSettingsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: SystemSettings
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = _context.SystemSettings.Include(s => s.CreatedBy).Include(s => s.ModifiedBy).Where(e => e.DelTime == null);
            return View(await applicationDbContext.ToListAsync());
        }

        // GET: SystemSettings/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemSetting = await _context.SystemSettings
                .Include(s => s.CreatedBy)
                .Include(s => s.ModifiedBy)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemSetting == null)
            {
                return NotFound();
            }

            return View(systemSetting);
        }

        // GET: SystemSettings/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: SystemSettings/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(SystemSetting systemSetting)
        {
            try
            {
                var userId = User.GetUserId();

                systemSetting.CreatedOn = DateTime.Now;
                systemSetting.CreatedById = userId;

                _context.Add(systemSetting);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "System setting Created";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(systemSetting);
            }
        }

        // GET: SystemSettings/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemSetting = await _context.SystemSettings.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemSetting == null)
            {
                return NotFound();
            }
            return View(systemSetting);
        }

        // POST: SystemSettings/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, SystemSetting systemSetting)
        {
            if (id != systemSetting.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                systemSetting.ModifiedOn = DateTime.Now;
                systemSetting.ModifiedById = userId;

                _context.Update(systemSetting);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "System setting Updated";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(systemSetting);
            }
        }

        // GET: SystemSettings/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemSetting = await _context.SystemSettings
                .Include(s => s.CreatedBy)
                .Include(s => s.ModifiedBy)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemSetting == null)
            {
                return NotFound();
            }

            return View(systemSetting);
        }

        // POST: SystemSettings/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            try
            {
                var userId = User.GetUserId();

                var systemSetting = await _context.SystemSettings.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

                if (systemSetting != null)
                {
                    //_context.SystemSettings.Remove(systemSetting);

                    systemSetting.DelTime = DateTime.Now;

                    _context.Update(systemSetting);
                }
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "System setting Deleted";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool SystemSettingExists(int id)
        {
            return _context.SystemSettings.Any(e => e.Id == id && e.DelTime == null);
        }
    }
}
