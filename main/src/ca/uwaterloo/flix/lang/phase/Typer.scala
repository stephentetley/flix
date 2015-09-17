package ca.uwaterloo.flix.lang.phase

import ca.uwaterloo.flix.lang.ast.{TypedAst, ResolvedAst}

import util.Validation
import util.Validation._

object Typer {

  import TypeError._

  sealed trait TypeError

  object TypeError {
    // TODO
  }


  def typecheck(rast: ResolvedAst) = ???

  object Literal {
    // def typer()
  }

  object Expression {

    // TODO: locals: Map[String, TypedAst.Type], globals: Map[???, TypedAst.Type]
    def typer(rast: ResolvedAst.Expression): Validation[TypedAst.Expression, TypeError] = rast match {
      case ResolvedAst.Expression.Var(ident) => ??? // pull type out of map.

      case ResolvedAst.Expression.Ref(name, decl) => ??? // todo then the declaration must have a type...

      case ResolvedAst.Expression.Let(ident, value, body) =>
        typer(value) map {
          case valueTpe => typer(body) // pass ident.name -> valueTpe
        }
        ???

      case ResolvedAst.Expression.IfThenElse(re1, re2, re3) =>
        @@(typer(re1), typer(re2), typer(re3)) flatMap {
          case (e1, e2, e3) =>
            val conditionType = expect(TypedAst.Type.Bool)(e1.tpe)
            val expressionType = expectEqual(e2.tpe, e3.tpe)
            #@(conditionType, expressionType) map {
              case tpe => TypedAst.Expression.IfThenElse(e1, e2, e3, tpe)
            }
        }
    }

  }


  def expect(tpe1: TypedAst.Type)(tpe2: TypedAst.Type): Validation[TypedAst.Type, TypeError] = ???

  def expectEqual(tpe1: TypedAst.Type, tpe2: TypedAst.Type): Validation[TypedAst.Type, TypeError] = ???

}
