using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HelpDeskSystem.Data.Migrations
{
    /// <inheritdoc />
    public partial class moreTicket : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "SubCategoryId",
                table: "Tickets",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Tickets_SubCategoryId",
                table: "Tickets",
                column: "SubCategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Tickets_TicketSubCategories_SubCategoryId",
                table: "Tickets",
                column: "SubCategoryId",
                principalTable: "TicketSubCategories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Tickets_TicketSubCategories_SubCategoryId",
                table: "Tickets");

            migrationBuilder.DropIndex(
                name: "IX_Tickets_SubCategoryId",
                table: "Tickets");

            migrationBuilder.DropColumn(
                name: "SubCategoryId",
                table: "Tickets");
        }
    }
}
