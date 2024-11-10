using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HelpDeskSystem.Data.Migrations
{
    /// <inheritdoc />
    public partial class _3threply : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reply_AspNetUsers_ReplyToUserId",
                table: "Reply");

            migrationBuilder.DropForeignKey(
                name: "FK_Reply_AspNetUsers_UserIdReply",
                table: "Reply");

            migrationBuilder.DropForeignKey(
                name: "FK_Reply_Comments_CommentId",
                table: "Reply");

            migrationBuilder.DropForeignKey(
                name: "FK_Reply_Tickets_TicketId",
                table: "Reply");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Reply",
                table: "Reply");

            migrationBuilder.RenameTable(
                name: "Reply",
                newName: "Replies");

            migrationBuilder.RenameIndex(
                name: "IX_Reply_UserIdReply",
                table: "Replies",
                newName: "IX_Replies_UserIdReply");

            migrationBuilder.RenameIndex(
                name: "IX_Reply_TicketId",
                table: "Replies",
                newName: "IX_Replies_TicketId");

            migrationBuilder.RenameIndex(
                name: "IX_Reply_ReplyToUserId",
                table: "Replies",
                newName: "IX_Replies_ReplyToUserId");

            migrationBuilder.RenameIndex(
                name: "IX_Reply_CommentId",
                table: "Replies",
                newName: "IX_Replies_CommentId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Replies",
                table: "Replies",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Replies_AspNetUsers_ReplyToUserId",
                table: "Replies",
                column: "ReplyToUserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Replies_AspNetUsers_UserIdReply",
                table: "Replies",
                column: "UserIdReply",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Replies_Comments_CommentId",
                table: "Replies",
                column: "CommentId",
                principalTable: "Comments",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Replies_Tickets_TicketId",
                table: "Replies",
                column: "TicketId",
                principalTable: "Tickets",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Replies_AspNetUsers_ReplyToUserId",
                table: "Replies");

            migrationBuilder.DropForeignKey(
                name: "FK_Replies_AspNetUsers_UserIdReply",
                table: "Replies");

            migrationBuilder.DropForeignKey(
                name: "FK_Replies_Comments_CommentId",
                table: "Replies");

            migrationBuilder.DropForeignKey(
                name: "FK_Replies_Tickets_TicketId",
                table: "Replies");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Replies",
                table: "Replies");

            migrationBuilder.RenameTable(
                name: "Replies",
                newName: "Reply");

            migrationBuilder.RenameIndex(
                name: "IX_Replies_UserIdReply",
                table: "Reply",
                newName: "IX_Reply_UserIdReply");

            migrationBuilder.RenameIndex(
                name: "IX_Replies_TicketId",
                table: "Reply",
                newName: "IX_Reply_TicketId");

            migrationBuilder.RenameIndex(
                name: "IX_Replies_ReplyToUserId",
                table: "Reply",
                newName: "IX_Reply_ReplyToUserId");

            migrationBuilder.RenameIndex(
                name: "IX_Replies_CommentId",
                table: "Reply",
                newName: "IX_Reply_CommentId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Reply",
                table: "Reply",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Reply_AspNetUsers_ReplyToUserId",
                table: "Reply",
                column: "ReplyToUserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Reply_AspNetUsers_UserIdReply",
                table: "Reply",
                column: "UserIdReply",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Reply_Comments_CommentId",
                table: "Reply",
                column: "CommentId",
                principalTable: "Comments",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Reply_Tickets_TicketId",
                table: "Reply",
                column: "TicketId",
                principalTable: "Tickets",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
