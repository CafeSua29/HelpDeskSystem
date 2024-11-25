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
using HelpDeskSystem.ViewModels;
using HelpDeskSystem.Services;
using Microsoft.AspNetCore.Authorization;
using HelpDeskSystem.ClaimsManagement;
using ElmahCore;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission(":TICKETCATEGORIES")]
    public class TicketSubCategoriesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public TicketSubCategoriesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: TicketSubCategories
        public async Task<IActionResult> Index(int id, TicketSubCategoriesVM vm)
        {
            vm.TicketSubCategories = await _context.TicketSubCategories
                .Include(c => c.CreatedBy)
                .Include(c => c.ModifiedBy)
                .Include(c => c.Category)
                .Where(x => x.CategoryId == id && x.DelTime == null)
                .ToListAsync();

            vm.CategoryId = id;

            return View(vm);
        }

        public async Task<IActionResult> SubCategories(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var subCate = await _context.TicketSubCategories
                .Include(c => c.CreatedBy)
                .Include(c => c.ModifiedBy)
                .Include(c => c.Category)
                .Where(x => x.CategoryId == id && x.DelTime == null)
                .ToListAsync();

            ViewBag.CateId = id;

            return View(subCate);
        }

        // GET: TicketSubCategories/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticketSubCategory = await _context.TicketSubCategories
                .Include(t => t.Category)
                .Include(t => t.CreatedBy)
                .Include(t => t.ModifiedBy)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (ticketSubCategory == null)
            {
                return NotFound();
            }

            return View(ticketSubCategory);
        }

        // GET: TicketSubCategories/Create
        public IActionResult Create(int id)
        {
            if (id == null)
            {
                return NotFound();
            }

            TicketSubCategory ticketSubCategory = new TicketSubCategory();
            ticketSubCategory.CategoryId = id;

            return View(ticketSubCategory);
        }

        // POST: TicketSubCategories/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(TicketSubCategory ticketSubCategory)
        {
            try
            {
                var userId = User.GetUserId();

                ticketSubCategory.CreatedOn = DateTime.Now;
                ticketSubCategory.CreatedById = userId;
                ticketSubCategory.Id = 0;
                ticketSubCategory.DelAble = true;

                _context.Add(ticketSubCategory);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Sub-category Created";

                return RedirectToAction("SubCategories", new { id = ticketSubCategory.CategoryId });
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(ticketSubCategory);
            }
        }

        // GET: TicketSubCategories/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticketSubCategory = await _context.TicketSubCategories.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (ticketSubCategory == null)
            {
                return NotFound();
            }

            return View(ticketSubCategory);
        }

        // POST: TicketSubCategories/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, TicketSubCategory ticketSubCategory)
        {
            if (id != ticketSubCategory.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                ticketSubCategory.ModifiedOn = DateTime.Now;
                ticketSubCategory.ModifiedById = userId;

                _context.Update(ticketSubCategory);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Sub-category Updated";

                return RedirectToAction("SubCategories", new { id = ticketSubCategory.CategoryId });
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(ticketSubCategory);
            }
        }

        // GET: TicketSubCategories/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticketSubCategory = await _context.TicketSubCategories
                .Include(t => t.Category)
                .Include(t => t.CreatedBy)
                .Include(t => t.ModifiedBy)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (ticketSubCategory == null)
            {
                return NotFound();
            }

            return View(ticketSubCategory);
        }

        // POST: TicketSubCategories/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var ticketSubCategory = await _context.TicketSubCategories.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

            try
            {
                var userId = User.GetUserId();

                if (ticketSubCategory != null)
                {
                    //_context.TicketSubCategories.Remove(ticketSubCategory);

                    ticketSubCategory.DelTime = DateTime.Now;
                    _context.Update(ticketSubCategory);

                    var defaultsub = _context.TicketSubCategories.FirstOrDefault(c => c.Code == "Defaultsub" && c.DelTime == null);

                    var tickets = _context.Tickets.Where(c => c.SubCategoryId == id && c.DelTime == null).ToList();

                    foreach (var ticket in tickets)
                    {
                        ticket.SubCategoryId = defaultsub.Id;

                        _context.Update(ticket);
                    }
                }

                await _context.MySaveChangesAsync(userId);
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("SubCategories", new { id = ticketSubCategory.CategoryId });
        }

        private bool TicketSubCategoryExists(int id)
        {
            return _context.TicketSubCategories.Any(e => e.Id == id && e.DelTime == null);
        }
    }
}
