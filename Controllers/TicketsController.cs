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
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.ViewModels;
using Microsoft.IdentityModel.Tokens;
using AutoMapper;
using HelpDeskSystem.Services;
using ElmahCore;
using HelpDeskSystem.ClaimsManagement;
using Microsoft.AspNetCore.Authorization;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission("TICKETS:TICKET COMMENTS")]
    public class TicketsController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;

        private readonly IMapper _mapper;

        public TicketsController(ApplicationDbContext context, IConfiguration configuration, IMapper mapper)
        {
            _context = context;
            _configuration = configuration;
            _mapper = mapper;
        }

        [Permission("TICKETS:TICKET COMMENTS")]
        // GET: Tickets
        public async Task<IActionResult> Index(string Title, int StatusId, string CreatedById, string AssignedToId, DateTime CreatedOn)
        {
            var allticket = _context.Tickets
                .Include(c => c.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .Where(t => t.DelTime == null)
                .OrderByDescending(c => c.CreatedOn)
                .AsQueryable();

            if(!string.IsNullOrEmpty(Title))
            {
                allticket = allticket.Where(x => x.Title.Contains(Title) || x.Description.Contains(Title));
            }

            if(StatusId > 0)
            {
                allticket = allticket.Where(x => x.StatusId == StatusId);
            }

            if (!string.IsNullOrEmpty(CreatedById))
            {
                allticket = allticket.Where(x => x.CreatedById == CreatedById);
            }

            if (!string.IsNullOrEmpty(AssignedToId))
            {
                allticket = allticket.Where(x => x.AssignedToId == AssignedToId);
            }

            DateTime dt = new DateTime();

            if (DateTime.Compare(CreatedOn, dt) > 0)
            {
                allticket = allticket.Where(x => DateOnly.FromDateTime(x.CreatedOn).CompareTo(DateOnly.FromDateTime(CreatedOn)) == 0);
            }

            var tickets = await allticket.ToListAsync();

            List<TicketVM> ticketVMs = new List<TicketVM>();

            foreach (var ticket in tickets)
            {
                TicketVM ticketVM = new TicketVM();

                ticketVM.Ticket = ticket;

                ticketVM.Comments = _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == ticket.Id)
                .Count();

                ticketVMs.Add(ticketVM);
            }

            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Status"), "Id", "Description");
            ViewData["UsersId"] = new SelectList(_context.Users, "Id", "Name");

            var ss = await _context.SystemSettings
                .Where(x => x.Code == "TicketResolutionDays")
                .FirstOrDefaultAsync();

            ViewBag.Duration = ss.Value;

            return View(ticketVMs);
        }

        // GET: Tickets/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .FirstOrDefaultAsync(m => m.Id == id);

            ViewBag.Comments = await _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == id)
                .ToListAsync();

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "ResolutionStatus"), "Id", "Description");

            return View(ticket);
        }

        // GET: Tickets/Create
        public IActionResult Create()
        {
            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority"), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status"), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories, "Id", "Name");
            return View();
        }

        // POST: Tickets/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Ticket ticket, IFormFile attachment)
        {
            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority"), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status"), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories, "Id", "Name");

            try
            {
                if (attachment != null && attachment.Length > 0)
                {
                    var filename = ticket.Title + "_" + DateTime.Now.ToString("yyyy-MM-dd") + "_" + attachment.FileName;

                    var path = _configuration["FileSettings:UploadsFolder"];
                    var filepath = Path.Combine(path, filename);

                    var stream = new FileStream(filepath, FileMode.Create);
                    await attachment.CopyToAsync(stream);
                    ticket.Attachment = filename;
                }

                var userId = User.GetUserId();

                ticket.CreatedOn = DateTime.Now;
                ticket.CreatedById = userId;

                //automapper
                //var ticket = _mapper.Map(vm, new Ticket());

                _context.Add(ticket);
                await _context.SaveChangesAsync(userId);

                TempData["Message"] = "Ticket Created";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(ticket);
            }
        }

        // GET: Tickets/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets.FindAsync(id);
            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority"), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status"), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories, "Id", "Name");

            return View(ticket);
        }

        // POST: Tickets/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Ticket ticket, IFormFile attachment)
        {
            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority"), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status"), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories, "Id", "Name");

            if (id != ticket.Id)
            {
                return NotFound();
            }

            try
            {
                if (attachment != null)
                {
                    var filename = ticket.Title + "_" + DateTime.Now.ToString("yyyy-MM-dd") + "_" + attachment.FileName;

                    var path = _configuration["FileSettings:UploadsFolder"];
                    var filepath = Path.Combine(path, filename);

                    var stream = new FileStream(filepath, FileMode.Create);
                    await attachment.CopyToAsync(stream);
                    ticket.Attachment = filename;
                }

                var userId = User.GetUserId();

                ticket.ModifiedOn = DateTime.Now;
                ticket.ModifiedById = userId;

                _context.Update(ticket);
                await _context.SaveChangesAsync(userId);

                TempData["Message"] = "Ticket Updated";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(ticket);
            }
        }

        // GET: Tickets/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (ticket == null)
            {
                return NotFound();
            }

            return View(ticket);

            //ticket = await _context.Tickets.FindAsync(id);
            //if (ticket != null)
            //{
            //    _context.Tickets.Remove(ticket);
            //}

            //await _context.SaveChangesAsync();

            //TempData["Message"] = "Ticket Deleted";

            //return RedirectToAction(nameof(Index));
        }

        // POST: Tickets/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var userId = User.GetUserId();

            try
            {
                var ticket = await _context.Tickets.FindAsync(id);
                if (ticket != null)
                {
                    //_context.Tickets.Remove(ticket);

                    ticket.DelTime = DateTime.Now;

                    _context.Update(ticket);
                }

                await _context.SaveChangesAsync(userId);

                TempData["Message"] = "Ticket Deleted";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool TicketExists(int id)
        {
            return _context.Tickets.Any(e => e.Id == id);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddComment(int id, string Desc)
        {
            try
            {
                Comment comment = new Comment();

                var userId = User.GetUserId();

                comment.CreatedOn = DateTime.Now;
                comment.CreatedById = userId;
                comment.Id = 0;
                comment.TicketId = id;
                comment.Description = Desc;

                _context.Add(comment);
                await _context.SaveChangesAsync(userId);
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("Details", new { id = id });
        }
        public async Task<IActionResult> Resolve(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .FirstOrDefaultAsync(m => m.Id == id);

            ViewBag.Comments = await _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "ResolutionStatus"), "Id", "Description");

            return View(ticket);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Resolve(int id, string Desc, int StatusId)
        {
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "ResolutionStatus"), "Id", "Description");

            try
            {
                var statuscode = await _context.SystemCodeDetails
                .Include(c => c.SystemCode)
                .Where(c => c.SystemCode.Code == "ResolutionStatus" && c.Id == StatusId)
                .FirstOrDefaultAsync();

                var statusid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .Where(c => c.SystemCode.Code == "Status" && c.Code == statuscode.Code)
                    .FirstOrDefaultAsync();

                TicketResolution resolution = new TicketResolution();

                var userId = User.GetUserId();

                resolution.CreatedOn = DateTime.Now;
                resolution.CreatedById = userId;
                resolution.Id = 0;
                resolution.TicketId = id;
                resolution.Description = Desc;
                resolution.StatusId = statusid.Id;

                _context.Add(resolution);

                var ticket = await _context.Tickets.FindAsync(id);
                ticket.StatusId = statusid.Id;

                _context.Update(ticket);

                await _context.SaveChangesAsync(userId);
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("Resolve", new { id = id });
        }

        public async Task<IActionResult> Close(int id)
        {
            try
            {
                var closedstatusid = await _context.SystemCodeDetails
                .Include(c => c.SystemCode)
                .Where(c => c.SystemCode.Code == "Status" && c.Code == "Closed")
                .FirstOrDefaultAsync();

                TicketResolution resolution = new TicketResolution();

                var userId = User.GetUserId();

                resolution.CreatedOn = DateTime.Now;
                resolution.CreatedById = userId;
                resolution.Id = 0;
                resolution.TicketId = id;
                resolution.Description = "Closed by owner";
                resolution.StatusId = closedstatusid.Id;

                _context.Add(resolution);

                var ticket = await _context.Tickets.FindAsync(id);
                ticket.StatusId = closedstatusid.Id;

                _context.Update(ticket);

                await _context.SaveChangesAsync(userId);

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                var ticket = await _context.Tickets.FindAsync(id);
                return View(ticket);
            }
        }

        public async Task<IActionResult> ReOpen(int id)
        {
            try
            {
                var pendingstatusid = await _context.SystemCodeDetails
                .Include(c => c.SystemCode)
                .Where(c => c.SystemCode.Code == "Status" && c.Code == "Pending")
                .FirstOrDefaultAsync();

                TicketResolution resolution = new TicketResolution();

                var userId = User.GetUserId();

                resolution.CreatedOn = DateTime.Now;
                resolution.CreatedById = userId;
                resolution.Id = 0;
                resolution.TicketId = id;
                resolution.Description = "Re-open by owner";
                resolution.StatusId = pendingstatusid.Id;

                _context.Add(resolution);

                var ticket = await _context.Tickets.FindAsync(id);
                ticket.StatusId = pendingstatusid.Id;

                _context.Update(ticket);

                await _context.SaveChangesAsync(userId);

                TempData["Message"] = "Re-opened Ticket";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Assign(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .FirstOrDefaultAsync(m => m.Id == id);

            ViewBag.Comments = await _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["UsersId"] = new SelectList(_context.Users, "Id", "Name");

            return View(ticket);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Assign(int id, string UserId)
        {
            ViewData["UsersId"] = new SelectList(_context.Users, "Id", "Name");

            try
            {
                TicketResolution resolution = new TicketResolution();

                var userId = User.GetUserId();

                var user = await _context.Users.FindAsync(UserId);

                var assignedstatusid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .Where(c => c.SystemCode.Code == "Status" && c.Code == "Assigned")
                    .FirstOrDefaultAsync();

                resolution.CreatedOn = DateTime.Now;
                resolution.CreatedById = userId;
                resolution.Id = 0;
                resolution.TicketId = id;
                resolution.Description = "Assign to user " + user.Name;
                resolution.StatusId = assignedstatusid.Id;

                _context.Add(resolution);

                var ticket = await _context.Tickets.FindAsync(id);

                ticket.AssignedToId = UserId;
                ticket.AssignedTo = user;
                ticket.AssignedOn = DateTime.Now;
                ticket.StatusId = assignedstatusid.Id;

                _context.Update(ticket);

                await _context.SaveChangesAsync(userId);
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("Assign", new { id = id });
        }
    }
}
