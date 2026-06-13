// Generated from Sard.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class SardParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.9.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		AND=1, OR=2, NOT=3, MOD=4, TRUE=5, FALSE=6, PREPROCESSOR=7, TILDETILDE=8, 
		TYPEEQ=9, NEQ=10, NNEQ=11, LTE=12, GTE=13, INC=14, DEC=15, PLUS_ASSIGN=16, 
		MINUS_ASSIGN=17, PLUS=18, MINUS=19, STAR=20, SLASH=21, CARET=22, PERCENT=23, 
		AMPERSAND=24, BAR=25, BANG=26, TILDE=27, AT=28, EQ=29, LT=30, GT=31, LPAREN=32, 
		RPAREN=33, LBRACE=34, RBRACE=35, LBRACKET=36, RBRACKET=37, COLON=38, SEMI=39, 
		COMMA=40, DOT=41, CURRENCY_LITERAL=42, COLOR_LITERAL=43, HEX_LITERAL=44, 
		NUMBER_LITERAL=45, INTEGER_LITERAL=46, ESCAPE_SEQ=47, STRING_LITERAL=48, 
		IDENTIFIER=49, LINE_COMMENT=50, BLOCK_COMMENT=51, CURLY_BLOCK_COMMENT=52, 
		WS=53;
	public static final int
		RULE_program = 0, RULE_statement = 1, RULE_declaration = 2, RULE_type = 3, 
		RULE_parameterList = 4, RULE_parameter = 5, RULE_assignment = 6, RULE_lvalue = 7, 
		RULE_lvalueSuffix = 8, RULE_returnStatement = 9, RULE_block = 10, RULE_expression = 11, 
		RULE_logicalOrExpr = 12, RULE_logicalAndExpr = 13, RULE_comparisonExpr = 14, 
		RULE_comparisonChain = 15, RULE_typeCheckExpr = 16, RULE_additiveExpr = 17, 
		RULE_multiplicativeExpr = 18, RULE_powerExpr = 19, RULE_unaryExpr = 20, 
		RULE_postfixExpr = 21, RULE_postfixLink = 22, RULE_argumentList = 23, 
		RULE_namedBlock = 24, RULE_primaryExpr = 25, RULE_literal = 26, RULE_arrayLiteral = 27;
	private static String[] makeRuleNames() {
		return new String[] {
			"program", "statement", "declaration", "type", "parameterList", "parameter", 
			"assignment", "lvalue", "lvalueSuffix", "returnStatement", "block", "expression", 
			"logicalOrExpr", "logicalAndExpr", "comparisonExpr", "comparisonChain", 
			"typeCheckExpr", "additiveExpr", "multiplicativeExpr", "powerExpr", "unaryExpr", 
			"postfixExpr", "postfixLink", "argumentList", "namedBlock", "primaryExpr", 
			"literal", "arrayLiteral"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, "'~~'", "'=='", "'<>'", 
			"'!='", "'<='", "'>='", "'++'", "'--'", "'+='", "'-='", "'+'", "'-'", 
			"'*'", "'/'", "'^'", "'%'", "'&'", "'|'", "'!'", "'~'", "'@'", "'='", 
			"'<'", "'>'", "'('", "')'", "'{'", "'}'", "'['", "']'", "':'", "';'", 
			"','", "'.'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "AND", "OR", "NOT", "MOD", "TRUE", "FALSE", "PREPROCESSOR", "TILDETILDE", 
			"TYPEEQ", "NEQ", "NNEQ", "LTE", "GTE", "INC", "DEC", "PLUS_ASSIGN", "MINUS_ASSIGN", 
			"PLUS", "MINUS", "STAR", "SLASH", "CARET", "PERCENT", "AMPERSAND", "BAR", 
			"BANG", "TILDE", "AT", "EQ", "LT", "GT", "LPAREN", "RPAREN", "LBRACE", 
			"RBRACE", "LBRACKET", "RBRACKET", "COLON", "SEMI", "COMMA", "DOT", "CURRENCY_LITERAL", 
			"COLOR_LITERAL", "HEX_LITERAL", "NUMBER_LITERAL", "INTEGER_LITERAL", 
			"ESCAPE_SEQ", "STRING_LITERAL", "IDENTIFIER", "LINE_COMMENT", "BLOCK_COMMENT", 
			"CURLY_BLOCK_COMMENT", "WS"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "Sard.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public SardParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	public static class ProgramContext extends ParserRuleContext {
		public TerminalNode EOF() { return getToken(SardParser.EOF, 0); }
		public List<StatementContext> statement() {
			return getRuleContexts(StatementContext.class);
		}
		public StatementContext statement(int i) {
			return getRuleContext(StatementContext.class,i);
		}
		public ProgramContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_program; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterProgram(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitProgram(this);
		}
	}

	public final ProgramContext program() throws RecognitionException {
		ProgramContext _localctx = new ProgramContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_program);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(59);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NOT) | (1L << TRUE) | (1L << FALSE) | (1L << TILDETILDE) | (1L << INC) | (1L << DEC) | (1L << PLUS) | (1L << MINUS) | (1L << BANG) | (1L << TILDE) | (1L << AT) | (1L << EQ) | (1L << LPAREN) | (1L << LBRACE) | (1L << LBRACKET) | (1L << SEMI) | (1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL) | (1L << IDENTIFIER))) != 0)) {
				{
				{
				setState(56);
				statement();
				}
				}
				setState(61);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(62);
			match(EOF);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StatementContext extends ParserRuleContext {
		public DeclarationContext declaration() {
			return getRuleContext(DeclarationContext.class,0);
		}
		public TerminalNode SEMI() { return getToken(SardParser.SEMI, 0); }
		public AssignmentContext assignment() {
			return getRuleContext(AssignmentContext.class,0);
		}
		public ReturnStatementContext returnStatement() {
			return getRuleContext(ReturnStatementContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public StatementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_statement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterStatement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitStatement(this);
		}
	}

	public final StatementContext statement() throws RecognitionException {
		StatementContext _localctx = new StatementContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_statement);
		try {
			setState(82);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,5,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(64);
				declaration();
				setState(66);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,1,_ctx) ) {
				case 1:
					{
					setState(65);
					match(SEMI);
					}
					break;
				}
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(68);
				assignment();
				setState(70);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
				case 1:
					{
					setState(69);
					match(SEMI);
					}
					break;
				}
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(72);
				returnStatement();
				setState(74);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
				case 1:
					{
					setState(73);
					match(SEMI);
					}
					break;
				}
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(76);
				expression();
				setState(78);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
				case 1:
					{
					setState(77);
					match(SEMI);
					}
					break;
				}
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(80);
				block();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(81);
				match(SEMI);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclarationContext extends ParserRuleContext {
		public DeclarationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declaration; }
	 
		public DeclarationContext() { }
		public void copyFrom(DeclarationContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class DeclTypedContext extends DeclarationContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode COLON() { return getToken(SardParser.COLON, 0); }
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TerminalNode SEMI() { return getToken(SardParser.SEMI, 0); }
		public DeclTypedContext(DeclarationContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterDeclTyped(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitDeclTyped(this);
		}
	}
	public static class DeclCallableNoParamsContext extends DeclarationContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode COLON() { return getToken(SardParser.COLON, 0); }
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public DeclCallableNoParamsContext(DeclarationContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterDeclCallableNoParams(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitDeclCallableNoParams(this);
		}
	}
	public static class DeclTypedInitContext extends DeclarationContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode COLON() { return getToken(SardParser.COLON, 0); }
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TerminalNode EQ() { return getToken(SardParser.EQ, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public DeclTypedInitContext(DeclarationContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterDeclTypedInit(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitDeclTypedInit(this);
		}
	}
	public static class DeclTypedCallableContext extends DeclarationContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode COLON() { return getToken(SardParser.COLON, 0); }
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public ParameterListContext parameterList() {
			return getRuleContext(ParameterListContext.class,0);
		}
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public DeclTypedCallableContext(DeclarationContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterDeclTypedCallable(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitDeclTypedCallable(this);
		}
	}
	public static class DeclForwardParamsContext extends DeclarationContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode COLON() { return getToken(SardParser.COLON, 0); }
		public ParameterListContext parameterList() {
			return getRuleContext(ParameterListContext.class,0);
		}
		public TerminalNode SEMI() { return getToken(SardParser.SEMI, 0); }
		public DeclForwardParamsContext(DeclarationContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterDeclForwardParams(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitDeclForwardParams(this);
		}
	}
	public static class DeclCallableParamsContext extends DeclarationContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode COLON() { return getToken(SardParser.COLON, 0); }
		public ParameterListContext parameterList() {
			return getRuleContext(ParameterListContext.class,0);
		}
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public DeclCallableParamsContext(DeclarationContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterDeclCallableParams(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitDeclCallableParams(this);
		}
	}

	public final DeclarationContext declaration() throws RecognitionException {
		DeclarationContext _localctx = new DeclarationContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_declaration);
		try {
			setState(119);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,10,_ctx) ) {
			case 1:
				_localctx = new DeclTypedInitContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(84);
				match(IDENTIFIER);
				setState(85);
				match(COLON);
				setState(86);
				type();
				setState(87);
				match(EQ);
				setState(88);
				expression();
				}
				break;
			case 2:
				_localctx = new DeclTypedCallableContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(90);
				match(IDENTIFIER);
				setState(91);
				match(COLON);
				setState(92);
				type();
				setState(94);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,6,_ctx) ) {
				case 1:
					{
					setState(93);
					parameterList();
					}
					break;
				}
				setState(97);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
				case 1:
					{
					setState(96);
					block();
					}
					break;
				}
				}
				break;
			case 3:
				_localctx = new DeclCallableParamsContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(99);
				match(IDENTIFIER);
				setState(100);
				match(COLON);
				setState(101);
				parameterList();
				setState(102);
				block();
				}
				break;
			case 4:
				_localctx = new DeclCallableNoParamsContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(104);
				match(IDENTIFIER);
				setState(105);
				match(COLON);
				setState(106);
				block();
				}
				break;
			case 5:
				_localctx = new DeclForwardParamsContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(107);
				match(IDENTIFIER);
				setState(108);
				match(COLON);
				setState(109);
				parameterList();
				setState(111);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,8,_ctx) ) {
				case 1:
					{
					setState(110);
					match(SEMI);
					}
					break;
				}
				}
				break;
			case 6:
				_localctx = new DeclTypedContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(113);
				match(IDENTIFIER);
				setState(114);
				match(COLON);
				setState(115);
				type();
				setState(117);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,9,_ctx) ) {
				case 1:
					{
					setState(116);
					match(SEMI);
					}
					break;
				}
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TypeContext extends ParserRuleContext {
		public List<TerminalNode> IDENTIFIER() { return getTokens(SardParser.IDENTIFIER); }
		public TerminalNode IDENTIFIER(int i) {
			return getToken(SardParser.IDENTIFIER, i);
		}
		public List<TerminalNode> DOT() { return getTokens(SardParser.DOT); }
		public TerminalNode DOT(int i) {
			return getToken(SardParser.DOT, i);
		}
		public TypeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_type; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterType(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitType(this);
		}
	}

	public final TypeContext type() throws RecognitionException {
		TypeContext _localctx = new TypeContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_type);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(121);
			match(IDENTIFIER);
			setState(126);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==DOT) {
				{
				{
				setState(122);
				match(DOT);
				setState(123);
				match(IDENTIFIER);
				}
				}
				setState(128);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ParameterListContext extends ParserRuleContext {
		public TerminalNode LPAREN() { return getToken(SardParser.LPAREN, 0); }
		public TerminalNode RPAREN() { return getToken(SardParser.RPAREN, 0); }
		public List<ParameterContext> parameter() {
			return getRuleContexts(ParameterContext.class);
		}
		public ParameterContext parameter(int i) {
			return getRuleContext(ParameterContext.class,i);
		}
		public List<TerminalNode> COMMA() { return getTokens(SardParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(SardParser.COMMA, i);
		}
		public ParameterListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameterList; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterParameterList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitParameterList(this);
		}
	}

	public final ParameterListContext parameterList() throws RecognitionException {
		ParameterListContext _localctx = new ParameterListContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_parameterList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(129);
			match(LPAREN);
			setState(138);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==IDENTIFIER) {
				{
				setState(130);
				parameter();
				setState(135);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(131);
					match(COMMA);
					setState(132);
					parameter();
					}
					}
					setState(137);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(140);
			match(RPAREN);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ParameterContext extends ParserRuleContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode COLON() { return getToken(SardParser.COLON, 0); }
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public ParameterContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameter; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterParameter(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitParameter(this);
		}
	}

	public final ParameterContext parameter() throws RecognitionException {
		ParameterContext _localctx = new ParameterContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_parameter);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(142);
			match(IDENTIFIER);
			setState(145);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==COLON) {
				{
				setState(143);
				match(COLON);
				setState(144);
				type();
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AssignmentContext extends ParserRuleContext {
		public LvalueContext lvalue() {
			return getRuleContext(LvalueContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TerminalNode EQ() { return getToken(SardParser.EQ, 0); }
		public TerminalNode PLUS_ASSIGN() { return getToken(SardParser.PLUS_ASSIGN, 0); }
		public TerminalNode MINUS_ASSIGN() { return getToken(SardParser.MINUS_ASSIGN, 0); }
		public AssignmentContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_assignment; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterAssignment(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitAssignment(this);
		}
	}

	public final AssignmentContext assignment() throws RecognitionException {
		AssignmentContext _localctx = new AssignmentContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_assignment);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(147);
			lvalue();
			setState(148);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << PLUS_ASSIGN) | (1L << MINUS_ASSIGN) | (1L << EQ))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(149);
			expression();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LvalueContext extends ParserRuleContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public List<LvalueSuffixContext> lvalueSuffix() {
			return getRuleContexts(LvalueSuffixContext.class);
		}
		public LvalueSuffixContext lvalueSuffix(int i) {
			return getRuleContext(LvalueSuffixContext.class,i);
		}
		public LvalueContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lvalue; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterLvalue(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitLvalue(this);
		}
	}

	public final LvalueContext lvalue() throws RecognitionException {
		LvalueContext _localctx = new LvalueContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_lvalue);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(151);
			match(IDENTIFIER);
			setState(155);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(152);
					lvalueSuffix();
					}
					} 
				}
				setState(157);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LvalueSuffixContext extends ParserRuleContext {
		public TerminalNode DOT() { return getToken(SardParser.DOT, 0); }
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode LBRACKET() { return getToken(SardParser.LBRACKET, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TerminalNode RBRACKET() { return getToken(SardParser.RBRACKET, 0); }
		public LvalueSuffixContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lvalueSuffix; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterLvalueSuffix(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitLvalueSuffix(this);
		}
	}

	public final LvalueSuffixContext lvalueSuffix() throws RecognitionException {
		LvalueSuffixContext _localctx = new LvalueSuffixContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_lvalueSuffix);
		try {
			setState(164);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case DOT:
				enterOuterAlt(_localctx, 1);
				{
				setState(158);
				match(DOT);
				setState(159);
				match(IDENTIFIER);
				}
				break;
			case LBRACKET:
				enterOuterAlt(_localctx, 2);
				{
				setState(160);
				match(LBRACKET);
				setState(161);
				expression();
				setState(162);
				match(RBRACKET);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ReturnStatementContext extends ParserRuleContext {
		public TerminalNode EQ() { return getToken(SardParser.EQ, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public ReturnStatementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_returnStatement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterReturnStatement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitReturnStatement(this);
		}
	}

	public final ReturnStatementContext returnStatement() throws RecognitionException {
		ReturnStatementContext _localctx = new ReturnStatementContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_returnStatement);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(166);
			match(EQ);
			setState(167);
			expression();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class BlockContext extends ParserRuleContext {
		public TerminalNode LBRACE() { return getToken(SardParser.LBRACE, 0); }
		public TerminalNode RBRACE() { return getToken(SardParser.RBRACE, 0); }
		public List<StatementContext> statement() {
			return getRuleContexts(StatementContext.class);
		}
		public StatementContext statement(int i) {
			return getRuleContext(StatementContext.class,i);
		}
		public BlockContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_block; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterBlock(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitBlock(this);
		}
	}

	public final BlockContext block() throws RecognitionException {
		BlockContext _localctx = new BlockContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_block);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(169);
			match(LBRACE);
			setState(173);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NOT) | (1L << TRUE) | (1L << FALSE) | (1L << TILDETILDE) | (1L << INC) | (1L << DEC) | (1L << PLUS) | (1L << MINUS) | (1L << BANG) | (1L << TILDE) | (1L << AT) | (1L << EQ) | (1L << LPAREN) | (1L << LBRACE) | (1L << LBRACKET) | (1L << SEMI) | (1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL) | (1L << IDENTIFIER))) != 0)) {
				{
				{
				setState(170);
				statement();
				}
				}
				setState(175);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(176);
			match(RBRACE);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExpressionContext extends ParserRuleContext {
		public LogicalOrExprContext logicalOrExpr() {
			return getRuleContext(LogicalOrExprContext.class,0);
		}
		public ExpressionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expression; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterExpression(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitExpression(this);
		}
	}

	public final ExpressionContext expression() throws RecognitionException {
		ExpressionContext _localctx = new ExpressionContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_expression);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(178);
			logicalOrExpr();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LogicalOrExprContext extends ParserRuleContext {
		public List<LogicalAndExprContext> logicalAndExpr() {
			return getRuleContexts(LogicalAndExprContext.class);
		}
		public LogicalAndExprContext logicalAndExpr(int i) {
			return getRuleContext(LogicalAndExprContext.class,i);
		}
		public List<TerminalNode> BAR() { return getTokens(SardParser.BAR); }
		public TerminalNode BAR(int i) {
			return getToken(SardParser.BAR, i);
		}
		public List<TerminalNode> OR() { return getTokens(SardParser.OR); }
		public TerminalNode OR(int i) {
			return getToken(SardParser.OR, i);
		}
		public LogicalOrExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_logicalOrExpr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterLogicalOrExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitLogicalOrExpr(this);
		}
	}

	public final LogicalOrExprContext logicalOrExpr() throws RecognitionException {
		LogicalOrExprContext _localctx = new LogicalOrExprContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_logicalOrExpr);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(180);
			logicalAndExpr();
			setState(185);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(181);
					_la = _input.LA(1);
					if ( !(_la==OR || _la==BAR) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(182);
					logicalAndExpr();
					}
					} 
				}
				setState(187);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LogicalAndExprContext extends ParserRuleContext {
		public List<ComparisonExprContext> comparisonExpr() {
			return getRuleContexts(ComparisonExprContext.class);
		}
		public ComparisonExprContext comparisonExpr(int i) {
			return getRuleContext(ComparisonExprContext.class,i);
		}
		public List<TerminalNode> AMPERSAND() { return getTokens(SardParser.AMPERSAND); }
		public TerminalNode AMPERSAND(int i) {
			return getToken(SardParser.AMPERSAND, i);
		}
		public List<TerminalNode> AND() { return getTokens(SardParser.AND); }
		public TerminalNode AND(int i) {
			return getToken(SardParser.AND, i);
		}
		public LogicalAndExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_logicalAndExpr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterLogicalAndExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitLogicalAndExpr(this);
		}
	}

	public final LogicalAndExprContext logicalAndExpr() throws RecognitionException {
		LogicalAndExprContext _localctx = new LogicalAndExprContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_logicalAndExpr);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(188);
			comparisonExpr();
			setState(193);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,19,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(189);
					_la = _input.LA(1);
					if ( !(_la==AND || _la==AMPERSAND) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(190);
					comparisonExpr();
					}
					} 
				}
				setState(195);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,19,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ComparisonExprContext extends ParserRuleContext {
		public TypeCheckExprContext typeCheckExpr() {
			return getRuleContext(TypeCheckExprContext.class,0);
		}
		public ComparisonChainContext comparisonChain() {
			return getRuleContext(ComparisonChainContext.class,0);
		}
		public ComparisonExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_comparisonExpr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterComparisonExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitComparisonExpr(this);
		}
	}

	public final ComparisonExprContext comparisonExpr() throws RecognitionException {
		ComparisonExprContext _localctx = new ComparisonExprContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_comparisonExpr);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(196);
			typeCheckExpr();
			setState(198);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,20,_ctx) ) {
			case 1:
				{
				setState(197);
				comparisonChain();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ComparisonChainContext extends ParserRuleContext {
		public List<TypeCheckExprContext> typeCheckExpr() {
			return getRuleContexts(TypeCheckExprContext.class);
		}
		public TypeCheckExprContext typeCheckExpr(int i) {
			return getRuleContext(TypeCheckExprContext.class,i);
		}
		public List<TerminalNode> EQ() { return getTokens(SardParser.EQ); }
		public TerminalNode EQ(int i) {
			return getToken(SardParser.EQ, i);
		}
		public List<TerminalNode> NEQ() { return getTokens(SardParser.NEQ); }
		public TerminalNode NEQ(int i) {
			return getToken(SardParser.NEQ, i);
		}
		public List<TerminalNode> NNEQ() { return getTokens(SardParser.NNEQ); }
		public TerminalNode NNEQ(int i) {
			return getToken(SardParser.NNEQ, i);
		}
		public List<TerminalNode> LT() { return getTokens(SardParser.LT); }
		public TerminalNode LT(int i) {
			return getToken(SardParser.LT, i);
		}
		public List<TerminalNode> GT() { return getTokens(SardParser.GT); }
		public TerminalNode GT(int i) {
			return getToken(SardParser.GT, i);
		}
		public List<TerminalNode> LTE() { return getTokens(SardParser.LTE); }
		public TerminalNode LTE(int i) {
			return getToken(SardParser.LTE, i);
		}
		public List<TerminalNode> GTE() { return getTokens(SardParser.GTE); }
		public TerminalNode GTE(int i) {
			return getToken(SardParser.GTE, i);
		}
		public ComparisonChainContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_comparisonChain; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterComparisonChain(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitComparisonChain(this);
		}
	}

	public final ComparisonChainContext comparisonChain() throws RecognitionException {
		ComparisonChainContext _localctx = new ComparisonChainContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_comparisonChain);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(202); 
			_errHandler.sync(this);
			_alt = 1;
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(200);
					_la = _input.LA(1);
					if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NEQ) | (1L << NNEQ) | (1L << LTE) | (1L << GTE) | (1L << EQ) | (1L << LT) | (1L << GT))) != 0)) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(201);
					typeCheckExpr();
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(204); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,21,_ctx);
			} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TypeCheckExprContext extends ParserRuleContext {
		public List<AdditiveExprContext> additiveExpr() {
			return getRuleContexts(AdditiveExprContext.class);
		}
		public AdditiveExprContext additiveExpr(int i) {
			return getRuleContext(AdditiveExprContext.class,i);
		}
		public TerminalNode TYPEEQ() { return getToken(SardParser.TYPEEQ, 0); }
		public TypeCheckExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typeCheckExpr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterTypeCheckExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitTypeCheckExpr(this);
		}
	}

	public final TypeCheckExprContext typeCheckExpr() throws RecognitionException {
		TypeCheckExprContext _localctx = new TypeCheckExprContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_typeCheckExpr);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(206);
			additiveExpr();
			setState(209);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,22,_ctx) ) {
			case 1:
				{
				setState(207);
				match(TYPEEQ);
				setState(208);
				additiveExpr();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AdditiveExprContext extends ParserRuleContext {
		public List<MultiplicativeExprContext> multiplicativeExpr() {
			return getRuleContexts(MultiplicativeExprContext.class);
		}
		public MultiplicativeExprContext multiplicativeExpr(int i) {
			return getRuleContext(MultiplicativeExprContext.class,i);
		}
		public List<TerminalNode> PLUS() { return getTokens(SardParser.PLUS); }
		public TerminalNode PLUS(int i) {
			return getToken(SardParser.PLUS, i);
		}
		public List<TerminalNode> MINUS() { return getTokens(SardParser.MINUS); }
		public TerminalNode MINUS(int i) {
			return getToken(SardParser.MINUS, i);
		}
		public AdditiveExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_additiveExpr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterAdditiveExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitAdditiveExpr(this);
		}
	}

	public final AdditiveExprContext additiveExpr() throws RecognitionException {
		AdditiveExprContext _localctx = new AdditiveExprContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_additiveExpr);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(211);
			multiplicativeExpr();
			setState(216);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,23,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(212);
					_la = _input.LA(1);
					if ( !(_la==PLUS || _la==MINUS) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(213);
					multiplicativeExpr();
					}
					} 
				}
				setState(218);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,23,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class MultiplicativeExprContext extends ParserRuleContext {
		public List<PowerExprContext> powerExpr() {
			return getRuleContexts(PowerExprContext.class);
		}
		public PowerExprContext powerExpr(int i) {
			return getRuleContext(PowerExprContext.class,i);
		}
		public List<TerminalNode> STAR() { return getTokens(SardParser.STAR); }
		public TerminalNode STAR(int i) {
			return getToken(SardParser.STAR, i);
		}
		public List<TerminalNode> SLASH() { return getTokens(SardParser.SLASH); }
		public TerminalNode SLASH(int i) {
			return getToken(SardParser.SLASH, i);
		}
		public List<TerminalNode> MOD() { return getTokens(SardParser.MOD); }
		public TerminalNode MOD(int i) {
			return getToken(SardParser.MOD, i);
		}
		public MultiplicativeExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_multiplicativeExpr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterMultiplicativeExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitMultiplicativeExpr(this);
		}
	}

	public final MultiplicativeExprContext multiplicativeExpr() throws RecognitionException {
		MultiplicativeExprContext _localctx = new MultiplicativeExprContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_multiplicativeExpr);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(219);
			powerExpr();
			setState(224);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,24,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(220);
					_la = _input.LA(1);
					if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << MOD) | (1L << STAR) | (1L << SLASH))) != 0)) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(221);
					powerExpr();
					}
					} 
				}
				setState(226);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,24,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PowerExprContext extends ParserRuleContext {
		public UnaryExprContext unaryExpr() {
			return getRuleContext(UnaryExprContext.class,0);
		}
		public TerminalNode CARET() { return getToken(SardParser.CARET, 0); }
		public PowerExprContext powerExpr() {
			return getRuleContext(PowerExprContext.class,0);
		}
		public PowerExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_powerExpr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPowerExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPowerExpr(this);
		}
	}

	public final PowerExprContext powerExpr() throws RecognitionException {
		PowerExprContext _localctx = new PowerExprContext(_ctx, getState());
		enterRule(_localctx, 38, RULE_powerExpr);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(227);
			unaryExpr();
			setState(230);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,25,_ctx) ) {
			case 1:
				{
				setState(228);
				match(CARET);
				setState(229);
				powerExpr();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class UnaryExprContext extends ParserRuleContext {
		public TerminalNode MINUS() { return getToken(SardParser.MINUS, 0); }
		public UnaryExprContext unaryExpr() {
			return getRuleContext(UnaryExprContext.class,0);
		}
		public TerminalNode PLUS() { return getToken(SardParser.PLUS, 0); }
		public TerminalNode BANG() { return getToken(SardParser.BANG, 0); }
		public TerminalNode NOT() { return getToken(SardParser.NOT, 0); }
		public TerminalNode INC() { return getToken(SardParser.INC, 0); }
		public LvalueContext lvalue() {
			return getRuleContext(LvalueContext.class,0);
		}
		public TerminalNode DEC() { return getToken(SardParser.DEC, 0); }
		public PostfixExprContext postfixExpr() {
			return getRuleContext(PostfixExprContext.class,0);
		}
		public UnaryExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_unaryExpr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterUnaryExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitUnaryExpr(this);
		}
	}

	public final UnaryExprContext unaryExpr() throws RecognitionException {
		UnaryExprContext _localctx = new UnaryExprContext(_ctx, getState());
		enterRule(_localctx, 40, RULE_unaryExpr);
		try {
			setState(245);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case MINUS:
				enterOuterAlt(_localctx, 1);
				{
				setState(232);
				match(MINUS);
				setState(233);
				unaryExpr();
				}
				break;
			case PLUS:
				enterOuterAlt(_localctx, 2);
				{
				setState(234);
				match(PLUS);
				setState(235);
				unaryExpr();
				}
				break;
			case BANG:
				enterOuterAlt(_localctx, 3);
				{
				setState(236);
				match(BANG);
				setState(237);
				unaryExpr();
				}
				break;
			case NOT:
				enterOuterAlt(_localctx, 4);
				{
				setState(238);
				match(NOT);
				setState(239);
				unaryExpr();
				}
				break;
			case INC:
				enterOuterAlt(_localctx, 5);
				{
				setState(240);
				match(INC);
				setState(241);
				lvalue();
				}
				break;
			case DEC:
				enterOuterAlt(_localctx, 6);
				{
				setState(242);
				match(DEC);
				setState(243);
				lvalue();
				}
				break;
			case TRUE:
			case FALSE:
			case TILDETILDE:
			case TILDE:
			case AT:
			case LPAREN:
			case LBRACE:
			case LBRACKET:
			case CURRENCY_LITERAL:
			case COLOR_LITERAL:
			case HEX_LITERAL:
			case NUMBER_LITERAL:
			case INTEGER_LITERAL:
			case ESCAPE_SEQ:
			case STRING_LITERAL:
			case IDENTIFIER:
				enterOuterAlt(_localctx, 7);
				{
				setState(244);
				postfixExpr();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PostfixExprContext extends ParserRuleContext {
		public PrimaryExprContext primaryExpr() {
			return getRuleContext(PrimaryExprContext.class,0);
		}
		public List<PostfixLinkContext> postfixLink() {
			return getRuleContexts(PostfixLinkContext.class);
		}
		public PostfixLinkContext postfixLink(int i) {
			return getRuleContext(PostfixLinkContext.class,i);
		}
		public PostfixExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_postfixExpr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPostfixExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPostfixExpr(this);
		}
	}

	public final PostfixExprContext postfixExpr() throws RecognitionException {
		PostfixExprContext _localctx = new PostfixExprContext(_ctx, getState());
		enterRule(_localctx, 42, RULE_postfixExpr);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(247);
			primaryExpr();
			setState(251);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,27,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(248);
					postfixLink();
					}
					} 
				}
				setState(253);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,27,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PostfixLinkContext extends ParserRuleContext {
		public PostfixLinkContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_postfixLink; }
	 
		public PostfixLinkContext() { }
		public void copyFrom(PostfixLinkContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class PostfixMemberContext extends PostfixLinkContext {
		public TerminalNode DOT() { return getToken(SardParser.DOT, 0); }
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public PostfixMemberContext(PostfixLinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPostfixMember(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPostfixMember(this);
		}
	}
	public static class PostfixBlockContext extends PostfixLinkContext {
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public PostfixBlockContext(PostfixLinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPostfixBlock(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPostfixBlock(this);
		}
	}
	public static class PostfixCallContext extends PostfixLinkContext {
		public ArgumentListContext argumentList() {
			return getRuleContext(ArgumentListContext.class,0);
		}
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public PostfixCallContext(PostfixLinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPostfixCall(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPostfixCall(this);
		}
	}
	public static class PostfixDecContext extends PostfixLinkContext {
		public TerminalNode DEC() { return getToken(SardParser.DEC, 0); }
		public PostfixDecContext(PostfixLinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPostfixDec(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPostfixDec(this);
		}
	}
	public static class PostfixIndexContext extends PostfixLinkContext {
		public TerminalNode LBRACKET() { return getToken(SardParser.LBRACKET, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TerminalNode RBRACKET() { return getToken(SardParser.RBRACKET, 0); }
		public PostfixIndexContext(PostfixLinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPostfixIndex(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPostfixIndex(this);
		}
	}
	public static class PostfixNamedBlockContext extends PostfixLinkContext {
		public NamedBlockContext namedBlock() {
			return getRuleContext(NamedBlockContext.class,0);
		}
		public PostfixNamedBlockContext(PostfixLinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPostfixNamedBlock(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPostfixNamedBlock(this);
		}
	}
	public static class PostfixIncContext extends PostfixLinkContext {
		public TerminalNode INC() { return getToken(SardParser.INC, 0); }
		public PostfixIncContext(PostfixLinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPostfixInc(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPostfixInc(this);
		}
	}
	public static class PostfixPercentContext extends PostfixLinkContext {
		public TerminalNode PERCENT() { return getToken(SardParser.PERCENT, 0); }
		public PostfixPercentContext(PostfixLinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPostfixPercent(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPostfixPercent(this);
		}
	}

	public final PostfixLinkContext postfixLink() throws RecognitionException {
		PostfixLinkContext _localctx = new PostfixLinkContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_postfixLink);
		try {
			setState(269);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case DOT:
				_localctx = new PostfixMemberContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(254);
				match(DOT);
				setState(255);
				match(IDENTIFIER);
				}
				break;
			case LBRACKET:
				_localctx = new PostfixIndexContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(256);
				match(LBRACKET);
				setState(257);
				expression();
				setState(258);
				match(RBRACKET);
				}
				break;
			case LPAREN:
				_localctx = new PostfixCallContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(260);
				argumentList();
				setState(262);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,28,_ctx) ) {
				case 1:
					{
					setState(261);
					block();
					}
					break;
				}
				}
				break;
			case IDENTIFIER:
				_localctx = new PostfixNamedBlockContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(264);
				namedBlock();
				}
				break;
			case LBRACE:
				_localctx = new PostfixBlockContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(265);
				block();
				}
				break;
			case PERCENT:
				_localctx = new PostfixPercentContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(266);
				match(PERCENT);
				}
				break;
			case INC:
				_localctx = new PostfixIncContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(267);
				match(INC);
				}
				break;
			case DEC:
				_localctx = new PostfixDecContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(268);
				match(DEC);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ArgumentListContext extends ParserRuleContext {
		public TerminalNode LPAREN() { return getToken(SardParser.LPAREN, 0); }
		public TerminalNode RPAREN() { return getToken(SardParser.RPAREN, 0); }
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public List<TerminalNode> COMMA() { return getTokens(SardParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(SardParser.COMMA, i);
		}
		public ArgumentListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_argumentList; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterArgumentList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitArgumentList(this);
		}
	}

	public final ArgumentListContext argumentList() throws RecognitionException {
		ArgumentListContext _localctx = new ArgumentListContext(_ctx, getState());
		enterRule(_localctx, 46, RULE_argumentList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(271);
			match(LPAREN);
			setState(280);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NOT) | (1L << TRUE) | (1L << FALSE) | (1L << TILDETILDE) | (1L << INC) | (1L << DEC) | (1L << PLUS) | (1L << MINUS) | (1L << BANG) | (1L << TILDE) | (1L << AT) | (1L << LPAREN) | (1L << LBRACE) | (1L << LBRACKET) | (1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL) | (1L << IDENTIFIER))) != 0)) {
				{
				setState(272);
				expression();
				setState(277);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(273);
					match(COMMA);
					setState(274);
					expression();
					}
					}
					setState(279);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(282);
			match(RPAREN);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class NamedBlockContext extends ParserRuleContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public ArgumentListContext argumentList() {
			return getRuleContext(ArgumentListContext.class,0);
		}
		public NamedBlockContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_namedBlock; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterNamedBlock(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitNamedBlock(this);
		}
	}

	public final NamedBlockContext namedBlock() throws RecognitionException {
		NamedBlockContext _localctx = new NamedBlockContext(_ctx, getState());
		enterRule(_localctx, 48, RULE_namedBlock);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(284);
			match(IDENTIFIER);
			setState(286);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==LPAREN) {
				{
				setState(285);
				argumentList();
				}
			}

			setState(288);
			block();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PrimaryExprContext extends ParserRuleContext {
		public PrimaryExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_primaryExpr; }
	 
		public PrimaryExprContext() { }
		public void copyFrom(PrimaryExprContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class PrimaryTrueContext extends PrimaryExprContext {
		public TerminalNode TRUE() { return getToken(SardParser.TRUE, 0); }
		public PrimaryTrueContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPrimaryTrue(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPrimaryTrue(this);
		}
	}
	public static class PrimaryLiteralContext extends PrimaryExprContext {
		public LiteralContext literal() {
			return getRuleContext(LiteralContext.class,0);
		}
		public PrimaryLiteralContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPrimaryLiteral(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPrimaryLiteral(this);
		}
	}
	public static class PrimaryRefContext extends PrimaryExprContext {
		public TerminalNode AT() { return getToken(SardParser.AT, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public PrimaryRefContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPrimaryRef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPrimaryRef(this);
		}
	}
	public static class PrimaryCloneContext extends PrimaryExprContext {
		public TerminalNode TILDETILDE() { return getToken(SardParser.TILDETILDE, 0); }
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public PrimaryCloneContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPrimaryClone(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPrimaryClone(this);
		}
	}
	public static class PrimaryFalseContext extends PrimaryExprContext {
		public TerminalNode FALSE() { return getToken(SardParser.FALSE, 0); }
		public PrimaryFalseContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPrimaryFalse(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPrimaryFalse(this);
		}
	}
	public static class PrimaryProtoContext extends PrimaryExprContext {
		public TerminalNode TILDE() { return getToken(SardParser.TILDE, 0); }
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public PrimaryProtoContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPrimaryProto(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPrimaryProto(this);
		}
	}
	public static class PrimaryParenContext extends PrimaryExprContext {
		public TerminalNode LPAREN() { return getToken(SardParser.LPAREN, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TerminalNode RPAREN() { return getToken(SardParser.RPAREN, 0); }
		public PrimaryParenContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPrimaryParen(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPrimaryParen(this);
		}
	}
	public static class PrimaryArrayContext extends PrimaryExprContext {
		public ArrayLiteralContext arrayLiteral() {
			return getRuleContext(ArrayLiteralContext.class,0);
		}
		public PrimaryArrayContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPrimaryArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPrimaryArray(this);
		}
	}
	public static class QualifiedOrSimpleIdContext extends PrimaryExprContext {
		public List<TerminalNode> IDENTIFIER() { return getTokens(SardParser.IDENTIFIER); }
		public TerminalNode IDENTIFIER(int i) {
			return getToken(SardParser.IDENTIFIER, i);
		}
		public List<TerminalNode> DOT() { return getTokens(SardParser.DOT); }
		public TerminalNode DOT(int i) {
			return getToken(SardParser.DOT, i);
		}
		public QualifiedOrSimpleIdContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterQualifiedOrSimpleId(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitQualifiedOrSimpleId(this);
		}
	}
	public static class PrimaryBlockContext extends PrimaryExprContext {
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public PrimaryBlockContext(PrimaryExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterPrimaryBlock(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitPrimaryBlock(this);
		}
	}

	public final PrimaryExprContext primaryExpr() throws RecognitionException {
		PrimaryExprContext _localctx = new PrimaryExprContext(_ctx, getState());
		enterRule(_localctx, 50, RULE_primaryExpr);
		try {
			int _alt;
			setState(313);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case CURRENCY_LITERAL:
			case COLOR_LITERAL:
			case HEX_LITERAL:
			case NUMBER_LITERAL:
			case INTEGER_LITERAL:
			case ESCAPE_SEQ:
			case STRING_LITERAL:
				_localctx = new PrimaryLiteralContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(290);
				literal();
				}
				break;
			case TRUE:
				_localctx = new PrimaryTrueContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(291);
				match(TRUE);
				}
				break;
			case FALSE:
				_localctx = new PrimaryFalseContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(292);
				match(FALSE);
				}
				break;
			case IDENTIFIER:
				_localctx = new QualifiedOrSimpleIdContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(293);
				match(IDENTIFIER);
				setState(298);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,33,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(294);
						match(DOT);
						setState(295);
						match(IDENTIFIER);
						}
						} 
					}
					setState(300);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,33,_ctx);
				}
				}
				break;
			case LPAREN:
				_localctx = new PrimaryParenContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(301);
				match(LPAREN);
				setState(302);
				expression();
				setState(303);
				match(RPAREN);
				}
				break;
			case LBRACE:
				_localctx = new PrimaryBlockContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(305);
				block();
				}
				break;
			case TILDE:
				_localctx = new PrimaryProtoContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(306);
				match(TILDE);
				setState(307);
				match(IDENTIFIER);
				}
				break;
			case TILDETILDE:
				_localctx = new PrimaryCloneContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(308);
				match(TILDETILDE);
				setState(309);
				match(IDENTIFIER);
				}
				break;
			case AT:
				_localctx = new PrimaryRefContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(310);
				match(AT);
				setState(311);
				expression();
				}
				break;
			case LBRACKET:
				_localctx = new PrimaryArrayContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(312);
				arrayLiteral();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LiteralContext extends ParserRuleContext {
		public TerminalNode INTEGER_LITERAL() { return getToken(SardParser.INTEGER_LITERAL, 0); }
		public TerminalNode NUMBER_LITERAL() { return getToken(SardParser.NUMBER_LITERAL, 0); }
		public TerminalNode HEX_LITERAL() { return getToken(SardParser.HEX_LITERAL, 0); }
		public TerminalNode STRING_LITERAL() { return getToken(SardParser.STRING_LITERAL, 0); }
		public TerminalNode COLOR_LITERAL() { return getToken(SardParser.COLOR_LITERAL, 0); }
		public TerminalNode CURRENCY_LITERAL() { return getToken(SardParser.CURRENCY_LITERAL, 0); }
		public TerminalNode ESCAPE_SEQ() { return getToken(SardParser.ESCAPE_SEQ, 0); }
		public LiteralContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_literal; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterLiteral(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitLiteral(this);
		}
	}

	public final LiteralContext literal() throws RecognitionException {
		LiteralContext _localctx = new LiteralContext(_ctx, getState());
		enterRule(_localctx, 52, RULE_literal);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(315);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ArrayLiteralContext extends ParserRuleContext {
		public TerminalNode LBRACKET() { return getToken(SardParser.LBRACKET, 0); }
		public TerminalNode RBRACKET() { return getToken(SardParser.RBRACKET, 0); }
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public List<TerminalNode> COMMA() { return getTokens(SardParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(SardParser.COMMA, i);
		}
		public ArrayLiteralContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_arrayLiteral; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).enterArrayLiteral(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof SardListener ) ((SardListener)listener).exitArrayLiteral(this);
		}
	}

	public final ArrayLiteralContext arrayLiteral() throws RecognitionException {
		ArrayLiteralContext _localctx = new ArrayLiteralContext(_ctx, getState());
		enterRule(_localctx, 54, RULE_arrayLiteral);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(317);
			match(LBRACKET);
			setState(326);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NOT) | (1L << TRUE) | (1L << FALSE) | (1L << TILDETILDE) | (1L << INC) | (1L << DEC) | (1L << PLUS) | (1L << MINUS) | (1L << BANG) | (1L << TILDE) | (1L << AT) | (1L << LPAREN) | (1L << LBRACE) | (1L << LBRACKET) | (1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL) | (1L << IDENTIFIER))) != 0)) {
				{
				setState(318);
				expression();
				setState(323);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(319);
					match(COMMA);
					setState(320);
					expression();
					}
					}
					setState(325);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(328);
			match(RBRACKET);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\67\u014d\4\2\t\2"+
		"\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\3\2\7\2<\n\2\f\2\16\2?\13\2\3"+
		"\2\3\2\3\3\3\3\5\3E\n\3\3\3\3\3\5\3I\n\3\3\3\3\3\5\3M\n\3\3\3\3\3\5\3"+
		"Q\n\3\3\3\3\3\5\3U\n\3\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\5\4a\n"+
		"\4\3\4\5\4d\n\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\5\4r\n"+
		"\4\3\4\3\4\3\4\3\4\5\4x\n\4\5\4z\n\4\3\5\3\5\3\5\7\5\177\n\5\f\5\16\5"+
		"\u0082\13\5\3\6\3\6\3\6\3\6\7\6\u0088\n\6\f\6\16\6\u008b\13\6\5\6\u008d"+
		"\n\6\3\6\3\6\3\7\3\7\3\7\5\7\u0094\n\7\3\b\3\b\3\b\3\b\3\t\3\t\7\t\u009c"+
		"\n\t\f\t\16\t\u009f\13\t\3\n\3\n\3\n\3\n\3\n\3\n\5\n\u00a7\n\n\3\13\3"+
		"\13\3\13\3\f\3\f\7\f\u00ae\n\f\f\f\16\f\u00b1\13\f\3\f\3\f\3\r\3\r\3\16"+
		"\3\16\3\16\7\16\u00ba\n\16\f\16\16\16\u00bd\13\16\3\17\3\17\3\17\7\17"+
		"\u00c2\n\17\f\17\16\17\u00c5\13\17\3\20\3\20\5\20\u00c9\n\20\3\21\3\21"+
		"\6\21\u00cd\n\21\r\21\16\21\u00ce\3\22\3\22\3\22\5\22\u00d4\n\22\3\23"+
		"\3\23\3\23\7\23\u00d9\n\23\f\23\16\23\u00dc\13\23\3\24\3\24\3\24\7\24"+
		"\u00e1\n\24\f\24\16\24\u00e4\13\24\3\25\3\25\3\25\5\25\u00e9\n\25\3\26"+
		"\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\5\26\u00f8"+
		"\n\26\3\27\3\27\7\27\u00fc\n\27\f\27\16\27\u00ff\13\27\3\30\3\30\3\30"+
		"\3\30\3\30\3\30\3\30\3\30\5\30\u0109\n\30\3\30\3\30\3\30\3\30\3\30\5\30"+
		"\u0110\n\30\3\31\3\31\3\31\3\31\7\31\u0116\n\31\f\31\16\31\u0119\13\31"+
		"\5\31\u011b\n\31\3\31\3\31\3\32\3\32\5\32\u0121\n\32\3\32\3\32\3\33\3"+
		"\33\3\33\3\33\3\33\3\33\7\33\u012b\n\33\f\33\16\33\u012e\13\33\3\33\3"+
		"\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\5\33\u013c\n\33"+
		"\3\34\3\34\3\35\3\35\3\35\3\35\7\35\u0144\n\35\f\35\16\35\u0147\13\35"+
		"\5\35\u0149\n\35\3\35\3\35\3\35\2\2\36\2\4\6\b\n\f\16\20\22\24\26\30\32"+
		"\34\36 \"$&(*,.\60\62\64\668\2\t\4\2\22\23\37\37\4\2\4\4\33\33\4\2\3\3"+
		"\32\32\4\2\f\17\37!\3\2\24\25\4\2\6\6\26\27\3\2,\62\2\u0170\2=\3\2\2\2"+
		"\4T\3\2\2\2\6y\3\2\2\2\b{\3\2\2\2\n\u0083\3\2\2\2\f\u0090\3\2\2\2\16\u0095"+
		"\3\2\2\2\20\u0099\3\2\2\2\22\u00a6\3\2\2\2\24\u00a8\3\2\2\2\26\u00ab\3"+
		"\2\2\2\30\u00b4\3\2\2\2\32\u00b6\3\2\2\2\34\u00be\3\2\2\2\36\u00c6\3\2"+
		"\2\2 \u00cc\3\2\2\2\"\u00d0\3\2\2\2$\u00d5\3\2\2\2&\u00dd\3\2\2\2(\u00e5"+
		"\3\2\2\2*\u00f7\3\2\2\2,\u00f9\3\2\2\2.\u010f\3\2\2\2\60\u0111\3\2\2\2"+
		"\62\u011e\3\2\2\2\64\u013b\3\2\2\2\66\u013d\3\2\2\28\u013f\3\2\2\2:<\5"+
		"\4\3\2;:\3\2\2\2<?\3\2\2\2=;\3\2\2\2=>\3\2\2\2>@\3\2\2\2?=\3\2\2\2@A\7"+
		"\2\2\3A\3\3\2\2\2BD\5\6\4\2CE\7)\2\2DC\3\2\2\2DE\3\2\2\2EU\3\2\2\2FH\5"+
		"\16\b\2GI\7)\2\2HG\3\2\2\2HI\3\2\2\2IU\3\2\2\2JL\5\24\13\2KM\7)\2\2LK"+
		"\3\2\2\2LM\3\2\2\2MU\3\2\2\2NP\5\30\r\2OQ\7)\2\2PO\3\2\2\2PQ\3\2\2\2Q"+
		"U\3\2\2\2RU\5\26\f\2SU\7)\2\2TB\3\2\2\2TF\3\2\2\2TJ\3\2\2\2TN\3\2\2\2"+
		"TR\3\2\2\2TS\3\2\2\2U\5\3\2\2\2VW\7\63\2\2WX\7(\2\2XY\5\b\5\2YZ\7\37\2"+
		"\2Z[\5\30\r\2[z\3\2\2\2\\]\7\63\2\2]^\7(\2\2^`\5\b\5\2_a\5\n\6\2`_\3\2"+
		"\2\2`a\3\2\2\2ac\3\2\2\2bd\5\26\f\2cb\3\2\2\2cd\3\2\2\2dz\3\2\2\2ef\7"+
		"\63\2\2fg\7(\2\2gh\5\n\6\2hi\5\26\f\2iz\3\2\2\2jk\7\63\2\2kl\7(\2\2lz"+
		"\5\26\f\2mn\7\63\2\2no\7(\2\2oq\5\n\6\2pr\7)\2\2qp\3\2\2\2qr\3\2\2\2r"+
		"z\3\2\2\2st\7\63\2\2tu\7(\2\2uw\5\b\5\2vx\7)\2\2wv\3\2\2\2wx\3\2\2\2x"+
		"z\3\2\2\2yV\3\2\2\2y\\\3\2\2\2ye\3\2\2\2yj\3\2\2\2ym\3\2\2\2ys\3\2\2\2"+
		"z\7\3\2\2\2{\u0080\7\63\2\2|}\7+\2\2}\177\7\63\2\2~|\3\2\2\2\177\u0082"+
		"\3\2\2\2\u0080~\3\2\2\2\u0080\u0081\3\2\2\2\u0081\t\3\2\2\2\u0082\u0080"+
		"\3\2\2\2\u0083\u008c\7\"\2\2\u0084\u0089\5\f\7\2\u0085\u0086\7*\2\2\u0086"+
		"\u0088\5\f\7\2\u0087\u0085\3\2\2\2\u0088\u008b\3\2\2\2\u0089\u0087\3\2"+
		"\2\2\u0089\u008a\3\2\2\2\u008a\u008d\3\2\2\2\u008b\u0089\3\2\2\2\u008c"+
		"\u0084\3\2\2\2\u008c\u008d\3\2\2\2\u008d\u008e\3\2\2\2\u008e\u008f\7#"+
		"\2\2\u008f\13\3\2\2\2\u0090\u0093\7\63\2\2\u0091\u0092\7(\2\2\u0092\u0094"+
		"\5\b\5\2\u0093\u0091\3\2\2\2\u0093\u0094\3\2\2\2\u0094\r\3\2\2\2\u0095"+
		"\u0096\5\20\t\2\u0096\u0097\t\2\2\2\u0097\u0098\5\30\r\2\u0098\17\3\2"+
		"\2\2\u0099\u009d\7\63\2\2\u009a\u009c\5\22\n\2\u009b\u009a\3\2\2\2\u009c"+
		"\u009f\3\2\2\2\u009d\u009b\3\2\2\2\u009d\u009e\3\2\2\2\u009e\21\3\2\2"+
		"\2\u009f\u009d\3\2\2\2\u00a0\u00a1\7+\2\2\u00a1\u00a7\7\63\2\2\u00a2\u00a3"+
		"\7&\2\2\u00a3\u00a4\5\30\r\2\u00a4\u00a5\7\'\2\2\u00a5\u00a7\3\2\2\2\u00a6"+
		"\u00a0\3\2\2\2\u00a6\u00a2\3\2\2\2\u00a7\23\3\2\2\2\u00a8\u00a9\7\37\2"+
		"\2\u00a9\u00aa\5\30\r\2\u00aa\25\3\2\2\2\u00ab\u00af\7$\2\2\u00ac\u00ae"+
		"\5\4\3\2\u00ad\u00ac\3\2\2\2\u00ae\u00b1\3\2\2\2\u00af\u00ad\3\2\2\2\u00af"+
		"\u00b0\3\2\2\2\u00b0\u00b2\3\2\2\2\u00b1\u00af\3\2\2\2\u00b2\u00b3\7%"+
		"\2\2\u00b3\27\3\2\2\2\u00b4\u00b5\5\32\16\2\u00b5\31\3\2\2\2\u00b6\u00bb"+
		"\5\34\17\2\u00b7\u00b8\t\3\2\2\u00b8\u00ba\5\34\17\2\u00b9\u00b7\3\2\2"+
		"\2\u00ba\u00bd\3\2\2\2\u00bb\u00b9\3\2\2\2\u00bb\u00bc\3\2\2\2\u00bc\33"+
		"\3\2\2\2\u00bd\u00bb\3\2\2\2\u00be\u00c3\5\36\20\2\u00bf\u00c0\t\4\2\2"+
		"\u00c0\u00c2\5\36\20\2\u00c1\u00bf\3\2\2\2\u00c2\u00c5\3\2\2\2\u00c3\u00c1"+
		"\3\2\2\2\u00c3\u00c4\3\2\2\2\u00c4\35\3\2\2\2\u00c5\u00c3\3\2\2\2\u00c6"+
		"\u00c8\5\"\22\2\u00c7\u00c9\5 \21\2\u00c8\u00c7\3\2\2\2\u00c8\u00c9\3"+
		"\2\2\2\u00c9\37\3\2\2\2\u00ca\u00cb\t\5\2\2\u00cb\u00cd\5\"\22\2\u00cc"+
		"\u00ca\3\2\2\2\u00cd\u00ce\3\2\2\2\u00ce\u00cc\3\2\2\2\u00ce\u00cf\3\2"+
		"\2\2\u00cf!\3\2\2\2\u00d0\u00d3\5$\23\2\u00d1\u00d2\7\13\2\2\u00d2\u00d4"+
		"\5$\23\2\u00d3\u00d1\3\2\2\2\u00d3\u00d4\3\2\2\2\u00d4#\3\2\2\2\u00d5"+
		"\u00da\5&\24\2\u00d6\u00d7\t\6\2\2\u00d7\u00d9\5&\24\2\u00d8\u00d6\3\2"+
		"\2\2\u00d9\u00dc\3\2\2\2\u00da\u00d8\3\2\2\2\u00da\u00db\3\2\2\2\u00db"+
		"%\3\2\2\2\u00dc\u00da\3\2\2\2\u00dd\u00e2\5(\25\2\u00de\u00df\t\7\2\2"+
		"\u00df\u00e1\5(\25\2\u00e0\u00de\3\2\2\2\u00e1\u00e4\3\2\2\2\u00e2\u00e0"+
		"\3\2\2\2\u00e2\u00e3\3\2\2\2\u00e3\'\3\2\2\2\u00e4\u00e2\3\2\2\2\u00e5"+
		"\u00e8\5*\26\2\u00e6\u00e7\7\30\2\2\u00e7\u00e9\5(\25\2\u00e8\u00e6\3"+
		"\2\2\2\u00e8\u00e9\3\2\2\2\u00e9)\3\2\2\2\u00ea\u00eb\7\25\2\2\u00eb\u00f8"+
		"\5*\26\2\u00ec\u00ed\7\24\2\2\u00ed\u00f8\5*\26\2\u00ee\u00ef\7\34\2\2"+
		"\u00ef\u00f8\5*\26\2\u00f0\u00f1\7\5\2\2\u00f1\u00f8\5*\26\2\u00f2\u00f3"+
		"\7\20\2\2\u00f3\u00f8\5\20\t\2\u00f4\u00f5\7\21\2\2\u00f5\u00f8\5\20\t"+
		"\2\u00f6\u00f8\5,\27\2\u00f7\u00ea\3\2\2\2\u00f7\u00ec\3\2\2\2\u00f7\u00ee"+
		"\3\2\2\2\u00f7\u00f0\3\2\2\2\u00f7\u00f2\3\2\2\2\u00f7\u00f4\3\2\2\2\u00f7"+
		"\u00f6\3\2\2\2\u00f8+\3\2\2\2\u00f9\u00fd\5\64\33\2\u00fa\u00fc\5.\30"+
		"\2\u00fb\u00fa\3\2\2\2\u00fc\u00ff\3\2\2\2\u00fd\u00fb\3\2\2\2\u00fd\u00fe"+
		"\3\2\2\2\u00fe-\3\2\2\2\u00ff\u00fd\3\2\2\2\u0100\u0101\7+\2\2\u0101\u0110"+
		"\7\63\2\2\u0102\u0103\7&\2\2\u0103\u0104\5\30\r\2\u0104\u0105\7\'\2\2"+
		"\u0105\u0110\3\2\2\2\u0106\u0108\5\60\31\2\u0107\u0109\5\26\f\2\u0108"+
		"\u0107\3\2\2\2\u0108\u0109\3\2\2\2\u0109\u0110\3\2\2\2\u010a\u0110\5\62"+
		"\32\2\u010b\u0110\5\26\f\2\u010c\u0110\7\31\2\2\u010d\u0110\7\20\2\2\u010e"+
		"\u0110\7\21\2\2\u010f\u0100\3\2\2\2\u010f\u0102\3\2\2\2\u010f\u0106\3"+
		"\2\2\2\u010f\u010a\3\2\2\2\u010f\u010b\3\2\2\2\u010f\u010c\3\2\2\2\u010f"+
		"\u010d\3\2\2\2\u010f\u010e\3\2\2\2\u0110/\3\2\2\2\u0111\u011a\7\"\2\2"+
		"\u0112\u0117\5\30\r\2\u0113\u0114\7*\2\2\u0114\u0116\5\30\r\2\u0115\u0113"+
		"\3\2\2\2\u0116\u0119\3\2\2\2\u0117\u0115\3\2\2\2\u0117\u0118\3\2\2\2\u0118"+
		"\u011b\3\2\2\2\u0119\u0117\3\2\2\2\u011a\u0112\3\2\2\2\u011a\u011b\3\2"+
		"\2\2\u011b\u011c\3\2\2\2\u011c\u011d\7#\2\2\u011d\61\3\2\2\2\u011e\u0120"+
		"\7\63\2\2\u011f\u0121\5\60\31\2\u0120\u011f\3\2\2\2\u0120\u0121\3\2\2"+
		"\2\u0121\u0122\3\2\2\2\u0122\u0123\5\26\f\2\u0123\63\3\2\2\2\u0124\u013c"+
		"\5\66\34\2\u0125\u013c\7\7\2\2\u0126\u013c\7\b\2\2\u0127\u012c\7\63\2"+
		"\2\u0128\u0129\7+\2\2\u0129\u012b\7\63\2\2\u012a\u0128\3\2\2\2\u012b\u012e"+
		"\3\2\2\2\u012c\u012a\3\2\2\2\u012c\u012d\3\2\2\2\u012d\u013c\3\2\2\2\u012e"+
		"\u012c\3\2\2\2\u012f\u0130\7\"\2\2\u0130\u0131\5\30\r\2\u0131\u0132\7"+
		"#\2\2\u0132\u013c\3\2\2\2\u0133\u013c\5\26\f\2\u0134\u0135\7\35\2\2\u0135"+
		"\u013c\7\63\2\2\u0136\u0137\7\n\2\2\u0137\u013c\7\63\2\2\u0138\u0139\7"+
		"\36\2\2\u0139\u013c\5\30\r\2\u013a\u013c\58\35\2\u013b\u0124\3\2\2\2\u013b"+
		"\u0125\3\2\2\2\u013b\u0126\3\2\2\2\u013b\u0127\3\2\2\2\u013b\u012f\3\2"+
		"\2\2\u013b\u0133\3\2\2\2\u013b\u0134\3\2\2\2\u013b\u0136\3\2\2\2\u013b"+
		"\u0138\3\2\2\2\u013b\u013a\3\2\2\2\u013c\65\3\2\2\2\u013d\u013e\t\b\2"+
		"\2\u013e\67\3\2\2\2\u013f\u0148\7&\2\2\u0140\u0145\5\30\r\2\u0141\u0142"+
		"\7*\2\2\u0142\u0144\5\30\r\2\u0143\u0141\3\2\2\2\u0144\u0147\3\2\2\2\u0145"+
		"\u0143\3\2\2\2\u0145\u0146\3\2\2\2\u0146\u0149\3\2\2\2\u0147\u0145\3\2"+
		"\2\2\u0148\u0140\3\2\2\2\u0148\u0149\3\2\2\2\u0149\u014a\3\2\2\2\u014a"+
		"\u014b\7\'\2\2\u014b9\3\2\2\2\'=DHLPT`cqwy\u0080\u0089\u008c\u0093\u009d"+
		"\u00a6\u00af\u00bb\u00c3\u00c8\u00ce\u00d3\u00da\u00e2\u00e8\u00f7\u00fd"+
		"\u0108\u010f\u0117\u011a\u0120\u012c\u013b\u0145\u0148";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}