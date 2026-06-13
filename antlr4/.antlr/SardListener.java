// Generated from Sard.g4 by ANTLR 4.9.2
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
	 * Enter a parse tree produced by the {@code DeclTypedInit}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void enterDeclTypedInit(SardParser.DeclTypedInitContext ctx);
	/**
	 * Exit a parse tree produced by the {@code DeclTypedInit}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void exitDeclTypedInit(SardParser.DeclTypedInitContext ctx);
	/**
	 * Enter a parse tree produced by the {@code DeclTypedCallable}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void enterDeclTypedCallable(SardParser.DeclTypedCallableContext ctx);
	/**
	 * Exit a parse tree produced by the {@code DeclTypedCallable}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void exitDeclTypedCallable(SardParser.DeclTypedCallableContext ctx);
	/**
	 * Enter a parse tree produced by the {@code DeclCallableParams}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void enterDeclCallableParams(SardParser.DeclCallableParamsContext ctx);
	/**
	 * Exit a parse tree produced by the {@code DeclCallableParams}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void exitDeclCallableParams(SardParser.DeclCallableParamsContext ctx);
	/**
	 * Enter a parse tree produced by the {@code DeclCallableNoParams}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void enterDeclCallableNoParams(SardParser.DeclCallableNoParamsContext ctx);
	/**
	 * Exit a parse tree produced by the {@code DeclCallableNoParams}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void exitDeclCallableNoParams(SardParser.DeclCallableNoParamsContext ctx);
	/**
	 * Enter a parse tree produced by the {@code DeclForwardParams}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void enterDeclForwardParams(SardParser.DeclForwardParamsContext ctx);
	/**
	 * Exit a parse tree produced by the {@code DeclForwardParams}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void exitDeclForwardParams(SardParser.DeclForwardParamsContext ctx);
	/**
	 * Enter a parse tree produced by the {@code DeclTyped}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void enterDeclTyped(SardParser.DeclTypedContext ctx);
	/**
	 * Exit a parse tree produced by the {@code DeclTyped}
	 * labeled alternative in {@link SardParser#declaration}.
	 * @param ctx the parse tree
	 */
	void exitDeclTyped(SardParser.DeclTypedContext ctx);
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
	 * Enter a parse tree produced by {@link SardParser#parameter}.
	 * @param ctx the parse tree
	 */
	void enterParameter(SardParser.ParameterContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#parameter}.
	 * @param ctx the parse tree
	 */
	void exitParameter(SardParser.ParameterContext ctx);
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
	 * Enter a parse tree produced by {@link SardParser#lvalueSuffix}.
	 * @param ctx the parse tree
	 */
	void enterLvalueSuffix(SardParser.LvalueSuffixContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#lvalueSuffix}.
	 * @param ctx the parse tree
	 */
	void exitLvalueSuffix(SardParser.LvalueSuffixContext ctx);
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
	 * Enter a parse tree produced by {@link SardParser#comparisonChain}.
	 * @param ctx the parse tree
	 */
	void enterComparisonChain(SardParser.ComparisonChainContext ctx);
	/**
	 * Exit a parse tree produced by {@link SardParser#comparisonChain}.
	 * @param ctx the parse tree
	 */
	void exitComparisonChain(SardParser.ComparisonChainContext ctx);
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
	 * Enter a parse tree produced by the {@code PostfixMember}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void enterPostfixMember(SardParser.PostfixMemberContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PostfixMember}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void exitPostfixMember(SardParser.PostfixMemberContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PostfixIndex}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void enterPostfixIndex(SardParser.PostfixIndexContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PostfixIndex}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void exitPostfixIndex(SardParser.PostfixIndexContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PostfixCall}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void enterPostfixCall(SardParser.PostfixCallContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PostfixCall}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void exitPostfixCall(SardParser.PostfixCallContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PostfixNamedBlock}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void enterPostfixNamedBlock(SardParser.PostfixNamedBlockContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PostfixNamedBlock}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void exitPostfixNamedBlock(SardParser.PostfixNamedBlockContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PostfixBlock}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void enterPostfixBlock(SardParser.PostfixBlockContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PostfixBlock}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void exitPostfixBlock(SardParser.PostfixBlockContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PostfixPercent}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void enterPostfixPercent(SardParser.PostfixPercentContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PostfixPercent}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void exitPostfixPercent(SardParser.PostfixPercentContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PostfixInc}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void enterPostfixInc(SardParser.PostfixIncContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PostfixInc}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void exitPostfixInc(SardParser.PostfixIncContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PostfixDec}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void enterPostfixDec(SardParser.PostfixDecContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PostfixDec}
	 * labeled alternative in {@link SardParser#postfixLink}.
	 * @param ctx the parse tree
	 */
	void exitPostfixDec(SardParser.PostfixDecContext ctx);
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
	 * Enter a parse tree produced by the {@code PrimaryLiteral}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryLiteral(SardParser.PrimaryLiteralContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PrimaryLiteral}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryLiteral(SardParser.PrimaryLiteralContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PrimaryTrue}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryTrue(SardParser.PrimaryTrueContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PrimaryTrue}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryTrue(SardParser.PrimaryTrueContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PrimaryFalse}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryFalse(SardParser.PrimaryFalseContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PrimaryFalse}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryFalse(SardParser.PrimaryFalseContext ctx);
	/**
	 * Enter a parse tree produced by the {@code QualifiedOrSimpleId}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterQualifiedOrSimpleId(SardParser.QualifiedOrSimpleIdContext ctx);
	/**
	 * Exit a parse tree produced by the {@code QualifiedOrSimpleId}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitQualifiedOrSimpleId(SardParser.QualifiedOrSimpleIdContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PrimaryParen}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryParen(SardParser.PrimaryParenContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PrimaryParen}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryParen(SardParser.PrimaryParenContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PrimaryBlock}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryBlock(SardParser.PrimaryBlockContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PrimaryBlock}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryBlock(SardParser.PrimaryBlockContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PrimaryProto}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryProto(SardParser.PrimaryProtoContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PrimaryProto}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryProto(SardParser.PrimaryProtoContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PrimaryClone}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryClone(SardParser.PrimaryCloneContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PrimaryClone}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryClone(SardParser.PrimaryCloneContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PrimaryRef}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryRef(SardParser.PrimaryRefContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PrimaryRef}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryRef(SardParser.PrimaryRefContext ctx);
	/**
	 * Enter a parse tree produced by the {@code PrimaryArray}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void enterPrimaryArray(SardParser.PrimaryArrayContext ctx);
	/**
	 * Exit a parse tree produced by the {@code PrimaryArray}
	 * labeled alternative in {@link SardParser#primaryExpr}.
	 * @param ctx the parse tree
	 */
	void exitPrimaryArray(SardParser.PrimaryArrayContext ctx);
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