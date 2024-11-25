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

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission(":TICKETCATEGORIES")]
    public class TicketCategoriesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public TicketCategoriesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: TicketCategories
        public async Task<IActionResult> Index(string Name, string CreatedById)
        {
            ViewData["UsersId"] = new SelectList(_context.Users.Where(e => e.DelTime == null), "Id", "Name");

            var allcategory = _context.TicketCategories
                .Include(t => t.CreatedBy)
                .Include(t => t.ModifiedBy)
                .Where(t => t.DelTime == null)
                .AsQueryable();

            if (!string.IsNullOrEmpty(Name))
            {
                allcategory = allcategory.Where(x => x.Name.Contains(Name));
            }

            if (!string.IsNullOrEmpty(CreatedById))
            {
                allcategory = allcategory.Where(x => x.CreatedById == CreatedById);
            }

            return View(await allcategory.ToListAsync());
        }

        // GET: TicketCategories/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticketCategory = await _context.TicketCategories
                .Include(t => t.CreatedBy)
                .Include(t => t.ModifiedBy)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (ticketCategory == null)
            {
                return NotFound();
            }

            return View(ticketCategory);
        }

        // GET: TicketCategories/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: TicketCategories/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(TicketCategory ticketCategory)
        {
            try
            {
                var userId = User.GetUserId();

                ticketCategory.CreatedOn = DateTime.Now;
                ticketCategory.CreatedById = userId;
                ticketCategory.DelAble = true;

                _context.Add(ticketCategory);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Category Created";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(ticketCategory);
            }
        }

        // GET: TicketCategories/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticketCategory = await _context.TicketCategories.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (ticketCategory == null)
            {
                return NotFound();
            }

            return View(ticketCategory);
        }

        // POST: TicketCategories/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, TicketCategory ticketCategory)
        {
            if (id != ticketCategory.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                ticketCategory.ModifiedOn = DateTime.Now;
                ticketCategory.ModifiedById = userId;

                _context.Update(ticketCategory);
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Category Updated";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(ticketCategory);
            }
        }

        // GET: TicketCategories/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticketCategory = await _context.TicketCategories
                .Include(t => t.CreatedBy)
                .Include(t => t.ModifiedBy)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

            if (ticketCategory == null)
            {
                return NotFound();
            }

            return View(ticketCategory);
        }

        // POST: TicketCategories/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            try
            {
                var userId = User.GetUserId();

                var ticketCategory = await _context.TicketCategories.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

                if (ticketCategory != null)
                {
                    //_context.TicketCategories.Remove(ticketCategory);

                    ticketCategory.DelTime = DateTime.Now;

                    _context.Update(ticketCategory);

                    var subcates = _context.TicketSubCategories.Where(c => c.CategoryId == id && c.DelTime == null).ToList();

                    foreach (var subcate in subcates)
                    {
                        var defaultsub = _context.TicketSubCategories.FirstOrDefault(c => c.Code == "Defaultsub" && c.DelTime == null);

                        var tickets = _context.Tickets.Where(c => c.SubCategoryId == subcate.Id && c.DelTime == null).ToList();

                        foreach (var ticket in tickets)
                        {
                            ticket.SubCategoryId = defaultsub.Id;

                            _context.Update(ticket);
                        }
                    }
                }
                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Category Deleted";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool TicketCategoryExists(int id)
        {
            return _context.TicketCategories.Any(e => e.Id == id && e.DelTime == null);
        }
    }
}
