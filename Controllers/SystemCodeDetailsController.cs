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
    public class SystemCodeDetailsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public SystemCodeDetailsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: SystemCodeDetails
        public async Task<IActionResult> Index()
        {
            var systemcodedetails = await _context.SystemCodeDetails
                .Include(c => c.CreatedBy)
                .Include(s => s.SystemCode)
                .OrderBy(o => o.OrderNo)
                .Where(e => e.DelTime == null)
                .ToListAsync();

            return View(systemcodedetails);
        }

        // GET: SystemCodeDetails/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemCodeDetail = await _context.SystemCodeDetails
                .Include(s => s.SystemCode)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemCodeDetail == null)
            {
                return NotFound();
            }

            return View(systemCodeDetail);
        }

        public async Task<IActionResult> SystemSubCode(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemcodedetails = await _context.SystemCodeDetails
                .Include(c => c.CreatedBy)
                .Include(s => s.SystemCode)
                .OrderBy(o => o.OrderNo)
                .Where(e => e.SystemCodeId == id && e.DelTime == null)
                .ToListAsync();

            ViewBag.SystemCodeId = id;

            return View(systemcodedetails);
        }

        // GET: SystemCodeDetails/Create
        public IActionResult Create(int id)
        {
            ViewData["SystemCodeId"] = new SelectList(_context.SystemCodes.Where(e => e.DelTime == null), "Id", "Description");

            if (id == null)
            {
                return NotFound();
            }

            SystemCodeDetail code = new SystemCodeDetail();
            code.SystemCodeId = id;

            return View(code);
        }

        // POST: SystemCodeDetails/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(SystemCodeDetail systemCodeDetail)
        {
            ViewData["SystemCodeId"] = new SelectList(_context.SystemCodes.Where(e => e.DelTime == null), "Id", "Description");

            try
            {
                var userId = User.GetUserId();

                systemCodeDetail.CreatedOn = DateTime.Now;
                systemCodeDetail.CreatedById = userId;
                systemCodeDetail.Id = 0;

                _context.Add(systemCodeDetail);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Details Created";

                return RedirectToAction("SystemSubCode", new { id = systemCodeDetail.SystemCodeId });
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(systemCodeDetail);
            }
        }

        // GET: SystemCodeDetails/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemCodeDetail = await _context.SystemCodeDetails.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemCodeDetail == null)
            {
                return NotFound();
            }

            return View(systemCodeDetail);
        }

        // POST: SystemCodeDetails/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, SystemCodeDetail systemCodeDetail)
        {
            if (id != systemCodeDetail.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                systemCodeDetail.ModifiedOn = DateTime.Now;
                systemCodeDetail.ModifiedById = userId;

                _context.Update(systemCodeDetail);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Details Updated";

                return RedirectToAction("SystemSubCode", new { id = systemCodeDetail.SystemCodeId });
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(systemCodeDetail);
            }
        }

        // GET: SystemCodeDetails/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemCodeDetail = await _context.SystemCodeDetails
                .Include(s => s.SystemCode)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemCodeDetail == null)
            {
                return NotFound();
            }

            return View(systemCodeDetail);
        }

        // POST: SystemCodeDetails/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var systemCodeDetail = await _context.SystemCodeDetails.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

            try
            {
                var userId = User.GetUserId();

                if (systemCodeDetail != null)
                {
                    //_context.SystemCodeDetails.Remove(systemCodeDetail);

                    systemCodeDetail.DelTime = DateTime.Now;
                    _context.Update(systemCodeDetail);
                }

                await _context.MySaveChangesAsync(userId);
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("SystemSubCode", new { id = systemCodeDetail.SystemCodeId });
        }

        private bool SystemCodeDetailExists(int id)
        {
            return _context.SystemCodeDetails.Any(e => e.Id == id && e.DelTime == null);
        }
    }
}
