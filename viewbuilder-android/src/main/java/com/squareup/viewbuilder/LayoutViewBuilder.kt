package com.squareup.viewbuilder

import android.content.Context
import android.support.annotation.LayoutRes
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.squareup.coordinators.Coordinator
import com.squareup.coordinators.Coordinators
import com.squareup.viewbuilder.ViewBuilder.Registry
import io.reactivex.Observable

class LayoutViewBuilder<T : Any> private constructor(
  override val type: String,
  @LayoutRes private val layoutId: Int,
  private val coordinatorConstructor: (Observable<out T>, Registry) -> Coordinator
) : ViewBuilder<T> {
  constructor(
    type: Class<T>,
    @LayoutRes layoutId: Int,
    coordinatorConstructor: (Observable<out T>, Registry) -> Coordinator
  ) : this(type.name, layoutId, coordinatorConstructor)

  override fun buildView(
    screens: Observable<out T>,
    builders: Registry,
    contextForNewView: Context,
    container: ViewGroup?
  ): View {
    return LayoutInflater.from(container?.context ?: contextForNewView)
        .cloneInContext(contextForNewView)
        .inflate(layoutId, container, false)
        .apply {
          Coordinators.bind(this) {
            coordinatorConstructor(screens, builders)
          }
        }
  }

  companion object {
    inline fun <reified T : Any> of(
      @LayoutRes layoutId: Int,
      noinline coordinatorConstructor: (Observable<out T>) -> Coordinator
    ) = of(
        layoutId
    ) { o: Observable<out T>, _ -> coordinatorConstructor(o) }

    inline fun <reified T : Any> of(
      @LayoutRes layoutId: Int,
      noinline coordinatorConstructor: (Observable<out T>, Registry) -> Coordinator
    ): LayoutViewBuilder<T> {
      return LayoutViewBuilder(
          T::class.java, layoutId, coordinatorConstructor
      )
    }
  }
}