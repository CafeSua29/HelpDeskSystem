using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Models;
using System.Security.Claims;
using HelpDeskSystem.Services;
using Microsoft.AspNetCore.Authorization;
using HelpDeskSystem.ClaimsManagement;
using ElmahCore;
using HelpDeskSystem.Data.Migrations;
using System.Net.Mail;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission(":SYSTEM")]
    public class SystemCodesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public SystemCodesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: SystemCodes
        public async Task<IActionResult> Index()
        {
            var systemcodes = await _context.SystemCodes
                .Include(c => c.CreatedBy)
                .Where(t => t.DelTime == null)
                .ToListAsync();

            return View(systemcodes);
        }

        // GET: SystemCodes/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemCode = await _context.SystemCodes.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemCode == null)
            {
                return NotFound();
            }

            return View(systemCode);
        }

        // GET: SystemCodes/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: SystemCodes/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(SystemCode systemCode)
        {
            try
            {
                var userId = User.GetUserId();

                systemCode.CreatedOn = DateTime.Now;
                systemCode.CreatedById = userId;
                systemCode.DelAble = true;

                _context.Add(systemCode);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "System code Created";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(systemCode);
            }
        }

        // GET: SystemCodes/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemCode = await _context.SystemCodes.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemCode == null)
            {
                return NotFound();
            }
            return View(systemCode);
        }

        // POST: SystemCodes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, SystemCode systemCode)
        {
            if (id != systemCode.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                systemCode.ModifiedOn = DateTime.Now;
                systemCode.ModifiedById = userId;

                _context.Update(systemCode);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "System code Updated";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(systemCode);
            }
        }

        // GET: SystemCodes/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemCode = await _context.SystemCodes.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemCode == null)
            {
                return NotFound();
            }

            return View(systemCode);
        }

        // POST: SystemCodes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            try
            {
                var userId = User.GetUserId();

                var systemCode = await _context.SystemCodes.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
                if (systemCode != null)
                {
                    //_context.SystemCodes.Remove(systemCode);

                    systemCode.DelTime = DateTime.Now;

                    _context.Update(systemCode);
                }
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "System code Deleted";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool SystemCodeExists(int id)
        {
            return _context.SystemCodes.Any(e => e.Id == id && e.DelTime == null);
        }
    }
}
