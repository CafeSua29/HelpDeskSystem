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
using Elmah.ContentSyndication;
using Microsoft.Extensions.Hosting;
using DocumentFormat.OpenXml.Office2010.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using Comment = HelpDeskSystem.Models.Comment;
using Azure.Core;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission(":TICKETS")]
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

        [Permission(":TICKETS")]
        // GET: Tickets
        public async Task<IActionResult> Index(string Title, int StatusId, int SubCateId, string CreatedById, DateTime CreatedOn)
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

            if (!string.IsNullOrEmpty(Title))
            {
                allticket = allticket.Where(x => x.Title.Contains(Title) || x.Description.Contains(Title));
            }

            if (StatusId > 0)
            {
                allticket = allticket.Where(x => x.StatusId == StatusId);
            }

            if (SubCateId > 0)
            {
                allticket = allticket.Where(x => x.SubCategoryId == SubCateId);
            }

            if (!string.IsNullOrEmpty(CreatedById))
            {
                allticket = allticket.Where(x => x.CreatedById == CreatedById);
            }

            DateTime dt = new DateTime();

            if (DateTime.Compare(CreatedOn, dt) > 0)
            {
                allticket = allticket.Where(x => DateOnly.FromDateTime(x.CreatedOn).CompareTo(DateOnly.FromDateTime(CreatedOn)) == 0);
            }

            List<Ticket> tickets = allticket.ToList();

            List<TicketVM> ticketVMs = new List<TicketVM>();

            foreach (Ticket ticket in tickets)
            {
                TicketVM ticketVM = new TicketVM();

                ticketVM.Ticket = ticket;

                ticketVM.Comments = _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == ticket.Id && c.DelTime == null)
                .Count();

                ticketVMs.Add(ticketVM);
            }

            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Status" && x.DelTime == null), "Id", "Description");

            ViewData["SubCateId"] = new SelectList(_context.TicketSubCategories
                .Include(x => x.Category)
                .Where(x => x.DelTime == null), "Id", "Name");

            ViewData["UsersId"] = new SelectList(_context.Users.Where(t => t.DelTime == null), "Id", "Name");

            var ss = await _context.SystemSettings
                .Where(x => x.Code == "TicketResolutionDays" && x.DelTime == null)
                .FirstOrDefaultAsync();

            ViewBag.Duration = ss.Value;

            return View(ticketVMs);
        }

        [Permission(":TICKETS")]
        // GET: Tickets
        public async Task<IActionResult> MyTickets(string id, string Title, int StatusId, int SubCateId, string CreatedById, DateTime CreatedOn)
        {
            var allticket = _context.Tickets
                .Include(c => c.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .Where(t => t.DelTime == null && t.CreatedById == id)
                .OrderByDescending(c => c.CreatedOn)
                .AsQueryable();

            if (!string.IsNullOrEmpty(Title))
            {
                allticket = allticket.Where(x => x.Title.Contains(Title) || x.Description.Contains(Title));
            }

            if (StatusId > 0)
            {
                allticket = allticket.Where(x => x.StatusId == StatusId);
            }

            if (SubCateId > 0)
            {
                allticket = allticket.Where(x => x.SubCategoryId == SubCateId);
            }

            if (!string.IsNullOrEmpty(CreatedById))
            {
                allticket = allticket.Where(x => x.CreatedById == CreatedById);
            }

            DateTime dt = new DateTime();

            if (DateTime.Compare(CreatedOn, dt) > 0)
            {
                allticket = allticket.Where(x => DateOnly.FromDateTime(x.CreatedOn).CompareTo(DateOnly.FromDateTime(CreatedOn)) == 0);
            }

            List<Ticket> tickets = allticket.ToList();

            List<TicketVM> ticketVMs = new List<TicketVM>();

            foreach (Ticket ticket in tickets)
            {
                TicketVM ticketVM = new TicketVM();

                ticketVM.Ticket = ticket;

                ticketVM.Comments = _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == ticket.Id && c.DelTime == null)
                .Count();

                ticketVMs.Add(ticketVM);
            }

            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails
                .Include(x => x.SystemCode)
                .Where(x => x.SystemCode.Code == "Status" && x.DelTime == null), "Id", "Description");

            ViewData["SubCateId"] = new SelectList(_context.TicketSubCategories
                .Include(x => x.Category)
                .Where(x => x.DelTime == null), "Id", "Name");

            ViewData["UsersId"] = new SelectList(_context.Users.Where(t => t.DelTime == null), "Id", "Name");

            var ss = await _context.SystemSettings
                .Where(x => x.Code == "TicketResolutionDays" && x.DelTime == null)
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
                .FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);

            ViewBag.Comments = await _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == id && c.DelTime == null)
                .ToListAsync();

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id && c.DelTime == null)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "ResolutionStatus" && x.DelTime == null), "Id", "Description");

            return View(ticket);
        }

        // GET: Tickets/Create
        public IActionResult Create()
        {
            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority" && x.DelTime == null), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status" && x.DelTime == null), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories.Where(x => x.DelTime == null), "Id", "Name");
            return View();
        }

        // POST: Tickets/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Ticket ticket, IFormFile Attachment)
        {
            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority" && x.DelTime == null), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status" && x.DelTime == null), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories.Where(x => x.DelTime == null), "Id", "Name");

            try
            {
                if (Attachment != null && Attachment.Length > 0)
                {
                    var filename = ticket.Title + "_" + DateTime.Now.ToString("yyyy-MM-dd") + "_" + Attachment.FileName;

                    var path = _configuration["FileSettings:UploadsFolder"];
                    var filepath = Path.Combine(path, filename);

                    using (var stream = new FileStream(filepath, FileMode.Create))
                    {
                        await Attachment.CopyToAsync(stream);
                    }
                    
                    ticket.Attachment = filename;
                }

                if (ticket.StatusId == 0 || ticket.PriorityId == 0)
                {
                    var pendingstatusid = await _context.SystemCodeDetails
                        .Include(c => c.SystemCode)
                        .FirstOrDefaultAsync(c => c.SystemCode.Code == "Status" && c.Code == "Pending" && c.DelTime == null);

                    var lowpriorityid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .FirstOrDefaultAsync(c => c.SystemCode.Code == "Priority" && c.Code == "Low" && c.DelTime == null);

                    ticket.StatusId = pendingstatusid.Id;
                    ticket.PriorityId = lowpriorityid.Id;
                }

                var userId = User.GetUserId();

                ticket.CreatedOn = DateTime.Now;
                ticket.CreatedById = userId;

                //automapper
                //var ticket = _mapper.Map(vm, new Ticket());

                _context.Add(ticket);
                await _context.MySaveChangesAsync(userId);

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

            var ticket = await _context.Tickets.Include(c => c.SubCategory).FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);
            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority" && x.DelTime == null), "Id", "Description", ticket.PriorityId);
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status" && x.DelTime == null), "Id", "Description", ticket.StatusId);
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories.Where(x => x.DelTime == null), "Id", "Name", ticket.SubCategory.CategoryId);

            return View(ticket);
        }

        // POST: Tickets/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Ticket ticket, string? Attachment, IFormFile? NewAttachment)
        {
            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority" && x.DelTime == null), "Id", "Description", ticket.PriorityId);
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status" && x.DelTime == null), "Id", "Description", ticket.StatusId);
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories.Where(x => x.DelTime == null), "Id", "Name");

            if (id != ticket.Id)
            {
                return NotFound();
            }

            try
            {
                if (NewAttachment != null)
                {
                    var path = _configuration["FileSettings:UploadsFolder"];

                    if (!string.IsNullOrEmpty(Attachment))
                    {
                        var filePath = Path.Combine(path, Attachment);

                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    var filename = ticket.Title + "_" + DateTime.Now.ToString("yyyy-MM-dd") + "_" + NewAttachment.FileName;

                    var filepath = Path.Combine(path, filename);

                    using (var stream = new FileStream(filepath, FileMode.Create))
                    {
                        await NewAttachment.CopyToAsync(stream);
                    }

                    ticket.Attachment = filename;
                }

                if (ticket.StatusId == 0 || ticket.PriorityId == 0)
                {
                    var pendingstatusid = await _context.SystemCodeDetails
                        .Include(c => c.SystemCode)
                        .FirstOrDefaultAsync(c => c.SystemCode.Code == "Status" && c.Code == "Pending" && c.DelTime == null);

                    var lowpriorityid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .FirstOrDefaultAsync(c => c.SystemCode.Code == "Priority" && c.Code == "Low" && c.DelTime == null);

                    ticket.StatusId = pendingstatusid.Id;
                    ticket.PriorityId = lowpriorityid.Id;
                }

                var userId = User.GetUserId();

                ticket.ModifiedOn = DateTime.Now;
                ticket.ModifiedById = userId;

                _context.Update(ticket);
                await _context.MySaveChangesAsync(userId);

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
                .FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);
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
            try
            {
                var userId = User.GetUserId();

                var ticket = await _context.Tickets.FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);
                if (ticket != null)
                {
                    //_context.Tickets.Remove(ticket);

                    var comments = await _context.Comments.Where(c => c.TicketId == id && c.DelTime == null).ToListAsync();

                    foreach (var comment in comments)
                    {
                        comment.DelTime = DateTime.Now;
                    }

                    var resolutions = await _context.TicketResolutions.Where(c => c.TicketId == id && c.DelTime == null).ToListAsync();

                    foreach (var resolution in resolutions)
                    {
                        resolution.DelTime = DateTime.Now;

                    }

                    ticket.DelTime = DateTime.Now;
                    _context.UpdateRange(comments);
                    _context.UpdateRange(resolutions);
                    _context.Update(ticket);
                }
                await _context.MySaveChangesAsync(userId);

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
            return _context.Tickets.Any(e => e.Id == id && e.DelTime == null);
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
                await _context.MySaveChangesAsync(userId);
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
                .FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id && c.DelTime == null)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "ResolutionStatus" && x.DelTime == null), "Id", "Description");

            return View(ticket);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Resolve(int id, string Desc, int StatusId)
        {
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "ResolutionStatus" && x.DelTime == null), "Id", "Description");

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id && c.DelTime == null)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            try
            {
                var statuscode = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .FirstOrDefaultAsync(c => c.SystemCode.Code == "ResolutionStatus" && c.Id == StatusId && c.DelTime == null);

                var statusid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .FirstOrDefaultAsync(c => c.SystemCode.Code == "Status" && c.Code == statuscode.Code && c.DelTime == null);

                TicketResolution resolution = new TicketResolution();

                var userId = User.GetUserId();

                resolution.CreatedOn = DateTime.Now;
                resolution.CreatedById = userId;
                resolution.Id = 0;
                resolution.TicketId = id;
                resolution.Description = Desc;
                resolution.StatusId = statusid.Id;

                _context.Add(resolution);

                var ticket = await _context.Tickets.FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);
                ticket.StatusId = statusid.Id;

                _context.Update(ticket);

                await _context.MySaveChangesAsync(userId);
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
                .FirstOrDefaultAsync(c => c.SystemCode.Code == "Status" && c.Code == "Closed" && c.DelTime == null);

                TicketResolution resolution = new TicketResolution();

                var userId = User.GetUserId();

                resolution.CreatedOn = DateTime.Now;
                resolution.CreatedById = userId;
                resolution.Id = 0;
                resolution.TicketId = id;
                resolution.Description = "Closed";
                resolution.StatusId = closedstatusid.Id;

                _context.Add(resolution);

                var ticket = await _context.Tickets.FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);
                ticket.StatusId = closedstatusid.Id;

                _context.Update(ticket);

                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Ticket Closed";

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return RedirectToAction("Resolve", new { id = id });
            }
        }

        public async Task<IActionResult> ReOpen(int id)
        {
            try
            {
                var waitingstatusid = await _context.SystemCodeDetails
                .Include(c => c.SystemCode)
                .FirstOrDefaultAsync(c => c.SystemCode.Code == "Status" && c.Code == "Pending" && c.DelTime == null);

                TicketResolution resolution = new TicketResolution();

                var userId = User.GetUserId();

                resolution.CreatedOn = DateTime.Now;
                resolution.CreatedById = userId;
                resolution.Id = 0;
                resolution.TicketId = id;
                resolution.Description = "Re-open";
                resolution.StatusId = waitingstatusid.Id;

                _context.Add(resolution);

                var ticket = await _context.Tickets.FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);
                ticket.StatusId = waitingstatusid.Id;

                _context.Update(ticket);

                await _context.MySaveChangesAsync(userId);

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
                .FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id && c.DelTime == null)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["UsersId"] = new SelectList(_context.Users.Where(c => c.DelTime == null), "Id", "Name", ticket.AssignedToId);

            return View(ticket);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Assign(int id, string UserId)
        {
            ViewData["UsersId"] = new SelectList(_context.Users.Where(c => c.DelTime == null), "Id", "Name");

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id && c.DelTime == null)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            try
            {
                TicketResolution resolution = new TicketResolution();

                var userId = User.GetUserId();

                var user = await _context.Users.FindAsync(UserId);

                var assignedstatusid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .FirstOrDefaultAsync(c => c.SystemCode.Code == "Status" && c.Code == "Assigned" && c.DelTime == null);

                var ticket = await _context.Tickets.FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);

                if (ticket.AssignedToId != null)
                {
                    if (ticket.AssignedToId.Equals(UserId))
                    {
                        TempData["Error"] = "This ticket is already assign to this user !";
                        return RedirectToAction("Assign", new { id = id });
                    }
                }

                ticket.AssignedToId = UserId;
                ticket.AssignedTo = user;
                ticket.AssignedOn = DateTime.Now;
                ticket.StatusId = assignedstatusid.Id;

                _context.Update(ticket);

                resolution.CreatedOn = DateTime.Now;
                resolution.CreatedById = userId;
                resolution.Id = 0;
                resolution.TicketId = id;
                resolution.Description = "Assign to user " + user.Name;
                resolution.StatusId = assignedstatusid.Id;

                _context.Add(resolution);

                await _context.MySaveChangesAsync(userId);

                TempData["Message"] = "Ticket assigned !";
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("Assign", new { id = id });
        }

        [HttpGet]
        public async Task<IActionResult> DownloadAttachment(string? fileName)
        {
            if (string.IsNullOrEmpty(fileName))
                return NotFound();

            var filePath = Path.Combine("ClientUpload", fileName);

            if (!System.IO.File.Exists(filePath))
            {
                return NotFound();
            }

            var memory = new MemoryStream();
            using (var stream = new FileStream(filePath, FileMode.Open))
            {
                await stream.CopyToAsync(memory);
            }
            memory.Position = 0;

            return File(memory, "application/octet-stream", fileName);
        }

        public async Task<IActionResult> Comment(int id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var userId = User.GetUserId();

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .FirstOrDefaultAsync(t => t.DelTime == null && t.Id == id);

            var cmts = await _context.Comments
                .Where(x => x.TicketId == id && x.ReplyId == null && x.DelTime == null)
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .OrderByDescending(c => c.VoteValue)
                .ToListAsync();

            var listCmtVoteVM = new List<CommentVoteVM>();

            foreach (var cmt in cmts)
            {
                var existingVote = await _context.Votes.FirstOrDefaultAsync(v => v.CommentId == cmt.Id && v.UserId == userId);

                var cmtVoteVM = new CommentVoteVM
                {
                    Comment = cmt,
                    CurrentUserVote = existingVote == null ? 0 : existingVote.Value
                };

                listCmtVoteVM.Add(cmtVoteVM);
            }

            ViewBag.Comments = listCmtVoteVM;

            ViewBag.Replies = await _context.Comments
                .Where(x => x.TicketId == id && x.ReplyId != null && x.DelTime == null)
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .OrderBy(c => c.CreatedOn)
                .ToListAsync();

            return View(ticket);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Comment(int id, string Desc, int? parentId, string? ownerId)
        {
            var userId = User.GetUserId();

            var cmts = await _context.Comments
                .Where(x => x.TicketId == id && x.ReplyId == null && x.DelTime == null)
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .OrderByDescending(c => c.VoteValue)
                .ToListAsync();

            var listCmtVoteVM = new List<CommentVoteVM>();

            foreach (var cmt in cmts)
            {
                var existingVote = await _context.Votes.FirstOrDefaultAsync(v => v.CommentId == cmt.Id && v.UserId == userId);

                var cmtVoteVM = new CommentVoteVM
                {
                    Comment = cmt,
                    CurrentUserVote = existingVote == null ? 0 : existingVote.Value
                };

                listCmtVoteVM.Add(cmtVoteVM);
            }

            ViewBag.Comments = listCmtVoteVM;

            ViewBag.Replies = await _context.Comments
                .Where(x => x.TicketId == id && x.ReplyId != null && x.DelTime == null)
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .OrderBy(c => c.CreatedOn)
                .ToListAsync();

            try
            {
                Comment comment = new Comment();

                comment.CreatedOn = DateTime.Now;
                comment.CreatedById = userId;
                comment.Id = 0;
                comment.TicketId = id;
                comment.Description = Desc;
                comment.VoteValue = 0;

                if (parentId != null && ownerId != null)
                {
                    var user = await _context.Users.FirstOrDefaultAsync(e => e.Id == ownerId && e.DelTime == null);

                    if (user != null)
                    {
                        comment.ReplyId = parentId;

                        var currUserId = User.GetUserId();

                        if (currUserId != ownerId)
                        {
                            user.Notification += 1;

                            _context.Update(user);

                            Reply reply = new Reply();
                            reply.Message = Desc;
                            reply.UserIdReply = userId;
                            reply.ReplyToUserId = ownerId;
                            reply.TicketId = id;
                            reply.CommentId = (int)parentId;
                            reply.ReplyOn = DateTime.Now;
                            reply.Id = 0;
                            reply.NotiMsg = "replied your comment:";

                            _context.Add(reply);
                        }
                    }
                }
                else
                {
                    var ticket = await _context.Tickets.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

                    if (ticket != null)
                    {
                        var user = await _context.Users.FirstOrDefaultAsync(e => e.Id == ticket.CreatedById && e.DelTime == null);

                        if (user != null)
                        {
                            var currUserId = User.GetUserId();

                            if (currUserId != ticket.CreatedById)
                            {
                                user.Notification += 1;

                                _context.Update(user);

                                Reply reply = new Reply();
                                reply.Message = Desc;
                                reply.UserIdReply = userId;
                                reply.ReplyToUserId = user.Id;
                                reply.TicketId = id;
                                reply.ReplyOn = DateTime.Now;
                                reply.Id = 0;
                                reply.NotiMsg = "commented in your ticket:";

                                _context.Add(reply);
                            }
                        }
                    }
                }

                _context.Add(comment);

                await _context.MySaveChangesAsync(userId);
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("Comment", new { id = id });
        }
    }
}
