using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Models;
using Microsoft.AspNetCore.Authorization;
using HelpDeskSystem.ClaimsManagement;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission("SYSTEM:AUDITTRAILS")]
    public class AuditTrailsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public AuditTrailsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: AuditTrails
        public async Task<IActionResult> Index(string ActionCode, string Module, string AffectedTable, string ByUserId)
        {
            var actioncode = await _context.SystemCodes.Where(x => x.Code == "Action").FirstOrDefaultAsync();

            ViewData["UsersId"] = new SelectList(_context.Users, "Id", "Name");
            ViewData["ActionCode"] = new SelectList(_context.SystemCodeDetails.Where(x => x.SystemCodeId == actioncode.Id), "Code", "Description");

            var allaudit = _context.AuditTrails
                .Include(a => a.User)
                .OrderByDescending(c => c.TimeStamp)
                .AsQueryable();

            var a = allaudit.Count();

            if (!string.IsNullOrEmpty(ActionCode))
            {
                allaudit = allaudit.Where(x => x.Action.Contains(ActionCode));
            }

            a = allaudit.Count();

            if (!string.IsNullOrEmpty(Module))
            {
                allaudit = allaudit.Where(x => x.Module.Contains(Module));
            }

            a = allaudit.Count();

            if (!string.IsNullOrEmpty(AffectedTable))
            {
                allaudit = allaudit.Where(x => x.AffectedTable.Contains(AffectedTable));
            }

            if (!string.IsNullOrEmpty(ByUserId))
            {
                allaudit = allaudit.Where(x => x.UserId == ByUserId);
            }

            return View(await allaudit.ToListAsync());
        }

        // GET: AuditTrails/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var auditTrail = await _context.AuditTrails
                .Include(a => a.User)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (auditTrail == null)
            {
                return NotFound();
            }

            return View(auditTrail);
        }

        // GET: AuditTrails/Create
        public IActionResult Create()
        {
            ViewData["UserId"] = new SelectList(_context.Users, "Id", "Id");
            return View();
        }

        // POST: AuditTrails/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Action,Module,AffectedTable,TimeStamp,IpAddress,UserId,OldValues,NewValues,AffectedColumns,DelTime,Note")] AuditTrail auditTrail)
        {
            if (ModelState.IsValid)
            {
                _context.Add(auditTrail);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["UserId"] = new SelectList(_context.Users, "Id", "Id", auditTrail.UserId);
            return View(auditTrail);
        }

        // GET: AuditTrails/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var auditTrail = await _context.AuditTrails.FindAsync(id);
            if (auditTrail == null)
            {
                return NotFound();
            }
            ViewData["UserId"] = new SelectList(_context.Users, "Id", "Id", auditTrail.UserId);
            return View(auditTrail);
        }

        // POST: AuditTrails/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Action,Module,AffectedTable,TimeStamp,IpAddress,UserId,OldValues,NewValues,AffectedColumns,DelTime,Note")] AuditTrail auditTrail)
        {
            if (id != auditTrail.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(auditTrail);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!AuditTrailExists(auditTrail.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["UserId"] = new SelectList(_context.Users, "Id", "Id", auditTrail.UserId);
            return View(auditTrail);
        }

        // GET: AuditTrails/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var auditTrail = await _context.AuditTrails
                .Include(a => a.User)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (auditTrail == null)
            {
                return NotFound();
            }

            return View(auditTrail);
        }

        // POST: AuditTrails/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var auditTrail = await _context.AuditTrails.FindAsync(id);
            if (auditTrail != null)
            {
                _context.AuditTrails.Remove(auditTrail);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool AuditTrailExists(int id)
        {
            return _context.AuditTrails.Any(e => e.Id == id);
        }
    }
}
