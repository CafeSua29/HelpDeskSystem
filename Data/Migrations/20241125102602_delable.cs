using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HelpDeskSystem.Data.Migrations
{
    /// <inheritdoc />
    public partial class delable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "UserRoleProfiles",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "TicketSubCategories",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "Tickets",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "TicketResolutions",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "TicketCategories",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "SystemTasks",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "SystemSettings",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "SystemCodes",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "SystemCodeDetails",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "Departments",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "DelAble",
                table: "Comments",
                type: "bit",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "UserRoleProfiles");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "TicketSubCategories");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "Tickets");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "TicketResolutions");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "TicketCategories");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "SystemTasks");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "SystemSettings");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "SystemCodes");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "SystemCodeDetails");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "Departments");

            migrationBuilder.DropColumn(
                name: "DelAble",
                table: "Comments");
        }
    }
}
