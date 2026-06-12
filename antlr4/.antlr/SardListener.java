// Generated from d:\\lab\\pascal\\sard\\antlr4\\Sard.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link SardParser}.
 */
public interface SardListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link SardParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(SardParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(SardParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#statement}.
	 * @param ctx the parse tree
	 */
	void enterStatement(SardParser.StatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#statement}.
	 * @param ctx the parse tree
	 */
	void exitStatement(SardParser.StatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void enterDeclaration(SardParser.DeclarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void exitDeclaration(SardParser.DeclarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#type}.
	 * @param ctx the parse tree
	 */
	void enterType(SardParser.TypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#type}.
	 * @param ctx the parse tree
	 */
	void exitType(SardParser.TypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#parameterList}.
	 * @param ctx the parse tree
	 */
	void enterParameterList(SardParser.ParameterListContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#parameterList}.
	 * @param ctx the parse tree
	 */
	void exitParameterList(SardParser.ParameterListContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#assignment}.
	 * @param ctx the parse tree
	 */
	void enterAssignment(SardParser.AssignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#assignment}.
	 * @param ctx the parse tree
	 */
	void exitAssignment(SardParser.AssignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void enterLvalue(SardParser.LvalueContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void exitLvalue(SardParser.LvalueContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#returnStatement}.
	 * @param ctx the parse tree
	 */
	void enterReturnStatement(SardParser.ReturnStatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#returnStatement}.
	 * @param ctx the parse tree
	 */
	void exitReturnStatement(SardParser.ReturnStatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#block}.
	 * @param ctx the parse tree
	 */
	void enterBlock(SardParser.BlockContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#block}.
	 * @param ctx the parse tree
	 */
	void exitBlock(SardParser.BlockContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression(SardParser.ExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression(SardParser.ExpressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#logicalOrExpr}.
	 * @param ctx the parse tree
	 */
	void enterLogicalOrExpr(SardParser.LogicalOrExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#logicalOrExpr}.
	 * @param ctx the parse tree
	 */
	void exitLogicalOrExpr(SardParser.LogicalOrExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#logicalAndExpr}.
	 * @param ctx the parse tree
	 */
	void enterLogicalAndExpr(SardParser.LogicalAndExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#logicalAndExpr}.
	 * @param ctx the parse tree
	 */
	void exitLogicalAndExpr(SardParser.LogicalAndExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#comparisonExpr}.
	 * @param ctx the parse tree
	 */
	void enterComparisonExpr(SardParser.ComparisonExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#comparisonExpr}.
	 * @param ctx the parse tree
	 */
	void exitComparisonExpr(SardParser.ComparisonExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#typeCheckExpr}.
	 * @param ctx the parse tree
	 */
	void enterTypeCheckExpr(SardParser.TypeCheckExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#typeCheckExpr}.
	 * @param ctx the parse tree
	 */
	void exitTypeCheckExpr(SardParser.TypeCheckExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#additiveExpr}.
	 * @param ctx the parse tree
	 */
	void enterAdditiveExpr(SardParser.AdditiveExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#additiveExpr}.
	 * @param ctx the parse tree
	 */
	void exitAdditiveExpr(SardParser.AdditiveExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#multiplicativeExpr}.
	 * @param ctx the parse tree
	 */
	void enterMultiplicativeExpr(SardParser.MultiplicativeExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#multiplicativeExpr}.
	 * @param ctx the parse tree
	 */
	void exitMultiplicativeExpr(SardParser.MultiplicativeExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#powerExpr}.
	 * @param ctx the parse tree
	 */
	void enterPowerExpr(SardParser.PowerExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#powerExpr}.
	 * @param ctx the parse tree
	 */
	void exitPowerExpr(SardParser.PowerExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#unaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterUnaryExpr(SardParser.UnaryExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#unaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitUnaryExpr(SardParser.UnaryExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#postfixExpr}.
	 * @param ctx the parse tree
	 */
	void enterPostfixExpr(SardParser.PostfixExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#postfixExpr}.
	 * @param ctx the parse tree
	 */
	void exitPostfixExpr(SardParser.PostfixExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void enterPostfixLink(SardParser.PostfixLinkContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void exitPostfixLink(SardParser.PostfixLinkContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#argumentList}.
	 * @param ctx the parse tree
	 */
	void enterArgumentList(SardParser.ArgumentListContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#argumentList}.
	 * @param ctx the parse tree
	 */
	void exitArgumentList(SardParser.ArgumentListContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#namedBlock}.
	 * @param ctx the parse tree
	 */
	void enterNamedBlock(SardParser.NamedBlockContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#namedBlock}.
	 * @param ctx the parse tree
	 */
	void exitNamedBlock(SardParser.NamedBlockContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryExpr(SardParser.PrimaryExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryExpr(SardParser.PrimaryExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#literal}.
	 * @param ctx the parse tree
	 */
	void enterLiteral(SardParser.LiteralContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#literal}.
	 * @param ctx the parse tree
	 */
	void exitLiteral(SardParser.LiteralContext ctx);
	/**
	 * Enter a parse tree produced by {@link SardParser#arrayLiteral}.
	 * @param ctx the parse tree
	 */
	void enterArrayLiteral(SardParser.ArrayLiteralContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#arrayLiteral}.
	 * @param ctx the parse tree
	 */
	void exitArrayLiteral(SardParser.ArrayLiteralContext ctx);
}