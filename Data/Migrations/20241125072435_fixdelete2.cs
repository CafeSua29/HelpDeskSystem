using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HelpDeskSystem.Data.Migrations
{
    /// <inheritdoc />
    public partial class fixdelete2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TicketResolutions_SystemCodeDetails_StatusId",
                table: "TicketResolutions");

            migrationBuilder.AddForeignKey(
                name: "FK_TicketResolutions_SystemCodeDetails_StatusId",
                table: "TicketResolutions",
                column: "StatusId",
                principalTable: "SystemCodeDetails",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TicketResolutions_SystemCodeDetails_StatusId",
                table: "TicketResolutions");

            migrationBuilder.AddForeignKey(
                name: "FK_TicketResolutions_SystemCodeDetails_StatusId",
                table: "TicketResolutions",
                column: "StatusId",
                principalTable: "SystemCodeDetails",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
