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
    public class SystemTasksController : Controller
    {
        private readonly ApplicationDbContext _context;

        public SystemTasksController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: SystemTasks
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = await _context.SystemTasks
                .Include(s => s.CreatedBy)
                .Include(s => s.ModifiedBy)
                .Include(s => s.Parent)
                .Where(e => e.DelTime == null)
                .ToListAsync();

            var suptask = new SystemTask();
            suptask.Name = "";

            foreach (var task in applicationDbContext)
            {
                if (task.Parent == null)
                    task.Parent = suptask;
            }

            return View(applicationDbContext);
        }

        // GET: SystemTasks/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemTask = await _context.SystemTasks
                .Include(s => s.CreatedBy)
                .Include(s => s.ModifiedBy)
                .Include(s => s.Parent)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemTask == null)
            {
                return NotFound();
            }

            return View(systemTask);
        }

        // GET: SystemTasks/Create
        public IActionResult Create()
        {
            ViewData["ParentId"] = new SelectList(_context.SystemTasks.Where(e => e.DelTime == null), "Id", "Name");
            return View();
        }

        // POST: SystemTasks/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(SystemTask systemTask)
        {
            ViewData["ParentId"] = new SelectList(_context.SystemTasks.Where(e => e.DelTime == null), "Id", "Name", systemTask.ParentId);

            try
            {
                var userId = User.GetUserId();

                systemTask.CreatedOn = DateTime.Now;
                systemTask.CreatedById = userId;

                _context.Add(systemTask);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "System task Created";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(systemTask);
            }
        }

        // GET: SystemTasks/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemTask = await _context.SystemTasks.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemTask == null)
            {
                return NotFound();
            }
            ViewData["ParentId"] = new SelectList(_context.SystemTasks.Where(e => e.DelTime == null), "Id", "Name", systemTask.ParentId);
            return View(systemTask);
        }

        // POST: SystemTasks/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, SystemTask systemTask)
        {
            ViewData["ParentId"] = new SelectList(_context.SystemTasks.Where(e => e.DelTime == null), "Id", "Name", systemTask.ParentId);

            if (id != systemTask.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                systemTask.ModifiedOn = DateTime.Now;
                systemTask.ModifiedById = userId;

                _context.Update(systemTask);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "System task Updated";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(systemTask);
            }
        }

        // GET: SystemTasks/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var systemTask = await _context.SystemTasks
                .Include(s => s.CreatedBy)
                .Include(s => s.ModifiedBy)
                .Include(s => s.Parent)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (systemTask == null)
            {
                return NotFound();
            }

            return View(systemTask);
        }

        // POST: SystemTasks/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            try
            {
                var userId = User.GetUserId();

                var systemTask = await _context.SystemTasks.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

                if (systemTask != null)
                {
                    //_context.SystemTasks.Remove(systemTask);

                    systemTask.DelTime = DateTime.Now;

                    _context.Update(systemTask);
                }

                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "System task Deleted";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool SystemTaskExists(int id)
        {
            return _context.SystemTasks.Any(e => e.Id == id && e.DelTime == null);
        }
    }
}
